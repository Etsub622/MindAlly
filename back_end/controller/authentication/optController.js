import { Otp } from "../../model/otpModel.js";
import randomstring from "randomstring";
import { sendEmail } from "../../utils/sendEmail.js";


function generateOTP() {
    return randomstring.generate({
        length: 4,
        charset: 'numeric'
    });
}

const sendOTPverification = async (req, res, next) => {
    try {
        const { email } = req.body;

        const expiresInMinutes = 100;
        const otp = generateOTP();

      
        const newOTP = new Otp({
            email,
            otp,
            expiresAt: new Date(Date.now() + expiresInMinutes * 60 * 1000), 
        });
        await newOTP.save();
        await sendEmail(email,otp);

        res.status(200).json({ success: true, message: 'OTP sent successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: "Internal server error" });
    }
};

const verifyOTP = async (req, res) => {
    try {
        const { email, otp } = req.body;  

    
        const otpRecord = await Otp.findOne({ otp, email });

      
        if (!otpRecord) {
            return res.status(400).json({ success: false, message: "Invalid OTP" });
        }

        
        if (otpRecord.expiresAt < Date.now()) {
            return res.status(400).json({ success: false, message: "OTP has expired" });
        }
        res.status(200).json({ success: true, message: "OTP verified successfully" });
        
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: "Internal server error" });
    }
};

export{sendOTPverification,verifyOTP}

