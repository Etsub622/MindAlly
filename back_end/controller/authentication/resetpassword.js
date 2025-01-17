import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";
import { hashedPassword } from "../../utils/authUtils.js";
import { Otp } from "../../model/otpModel.js";

const resetPassword = async (req, res) => {
    try {

        const { currentPassword, newPassword } = req.body;
        const token = req.header("Authorization")?.split(" ")[1];

         
        if (!token) {
            return res.status(401).json({err:"unauthorized access"})
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const { id, role } = decoded;
        const userModel = role === "patient" ? Patient : Therapist;
        const user = await userModel.findById(id);
       
         if (!user) {
            return res.status(404).json({ error: "User not found." });
        }
    
    
       
        const isMatch = await bcrypt.compare(currentPassword.trim(), user.Password);
      
    
        if (!isMatch) {
            return res.status(400).json({ error: "Current password is incorrect." });
        }
        console.log(isMatch)
        console.log(currentPassword)

        const hashedNewPassword = await hashedPassword(newPassword);
        user.Password = hashedNewPassword;
        await user.save();

    } catch (error) {
        console.error(error);
        if (error.name === "JsonWebTokenError") {
            return res.status(401).json({ error: "Invalid token." });
        }
        res.status(500).json({ error: "An error occurred during password reset." });
    }
        
}

const verifyPasswordResetOTP = async (req, res) => {
    try {
        const { email , otp } = req.body;

        if (!email || !otp) {
            return res.status(400).json({ success: false, message: "Email and OTP are required" });
        }
         const otpRecord = await Otp.findOne({ otp, email });
         if (!otpRecord) {
            return res.status(400).json({ success: false, message: "Invalid OTP" });
        }

        
        if (otpRecord.expiresAt < Date.now()) {
            return res.status(400).json({ success: false, message: "OTP has expired" });
        }
    
        const resetToken = jwt.sign({email}, process.env.JWT_SECRET, { expiresIn: "10m" });
        res.status(200).json({
            success: true,
            message: "OTP verified. Use the reset token to reset your password.",
            resetToken,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: "Internal server error" });
    }
};

const forgotPassword = async (req, res) => {
    try {
        const { resetToken, newPassword } = req.body;

        if (!resetToken || !newPassword) {
            return res.status(400).json({ success: false, message: "Reset token and new password are required" });
        }

    
        const decoded = jwt.verify(resetToken, process.env.JWT_SECRET);
        const { email } = decoded;
      
        const userModel = await Patient.findOne({ Email: email }) || await Therapist.findOne({ Email:email });


        if (!userModel) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

      
        userModel.Password = hashedPassword;
        await userModel.save();

        res.status(200).json({ success: true, message: "Password reset successfully" });
    } catch (err) {
        if (err.name === "TokenExpiredError") {
            return res.status(400).json({ success: false, message: "Reset token has expired" });
        }
        console.error(err);
        res.status(500).json({ success: false, message: "Internal server error" });
    }
};




export {resetPassword ,forgotPassword,verifyPasswordResetOTP}