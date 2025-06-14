import bcrypt from "bcrypt"
import { Therapist } from "../../model/therapistModel.js";
import { Patient } from "../../model/patientModel.js";
import { Admin } from "../../model/adminModel.js";
import { Token } from "../../model/token.js"
import jwt from "jsonwebtoken"

import { generateAccessToken, generateRefreshToken, hashedPassword } from "../../utils/authUtils.js";


const registerTherapist = async (req, res) => {
    try {

        const { fullName, email, password, specialization , certificate} = req.body
        
    
    const hashedPass= await hashedPassword(password)
    
    const therapist = new Therapist({
      FullName:fullName,
      Email:email,
      modality:specialization,
      Password: hashedPass,
      Certificate: certificate,
      Role: "pending_therapist",
      verified:false
      
    })
    
        await therapist.save()
        const token =generateAccessToken(therapist._id ,therapist.Role)
        res.status(200).json({
            message: "Therapist signup",
            token,
            user:therapist,})
        
    } catch (error) {
        console.log(error)
        
    }
   
    
}
const registerPatient = async (req, res) => {
    try {
      console.log('Received signup request:', req.body);

   const { fullName, email, password, collage,EmergencyEmail } = req.body
    
    const patient = new Patient({
      FullName:fullName,
      Email:email,
      Collage:collage,
      Password: hashpass,
      Role:"patient",
      EmergencyEmail

    })
    
        await patient.save()
        const token = generateAccessToken(patient._id,patient.Role)
        
        res.status(200).json({
            message: "patient signup successful",
            token,
            user:patient,
        })
        console.log('Signup successful');
        
    } catch (error) {
        console.log(error)
        
    }
   
    
}

const registerAdmin = async (req, res) => {
  try {

      const { fullName, email, password } = req.body

      console.log("Registering admin:", fullName, email, password);
      
      const hashpass=await hashedPassword(password)
  

  
  const admin = new Admin({
    FullName:fullName,
    Email:email,
    Password: hashpass,
    Role:"admin"
  })
  
      await admin.save()
      const token = generateAccessToken(admin._id, admin.Role)
      
      res.status(200).json({
          message: "admin signup successful",
          token,
          user:admin,
      })
      
  } catch (error) {
      console.log(error)
      
  }
 
  
}

const Login = async (req, res) => {
    try {
        const { email, password } = req.body;

       
        if (!email || !password) {
            return res.status(400).json({ error: "Email and Password are required." });
        }

           const userModel = await Patient.findOne({ Email: email }) || await Therapist.findOne({ Email:email }) || await Admin.findOne({ Email: email });
        if (!userModel) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(password, userModel.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });

      }
      userModel.lastLogin = new Date();
      await userModel.save();

  


        }
        
        console.log("User found:", userModel._id, userModel.Role);

        const accessToken = generateAccessToken(userModel._id, userModel.Role);
        const refreshToken = generateRefreshToken(userModel._id, userModel.Role);
        
        await Token.create({
        userId: userModel._id,
        userModel: userModel.Role === "patient" ? "Patient" : userModel.Role === "admin" ? "Admin" : "Therapist",
        refreshToken
        });
         res
      .cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: true,
        sameSite: "strict",
        maxAge: 3 * 24 * 60 * 60 * 1000 
      })
      .json({ message: "user login successful",accessToken, user: userModel  });
        
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

const refreshToken = async (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  if (!refreshToken) return res.sendStatus(401);

  try {
    const stored = await Token.findOne({ refreshToken });
    if (!stored) return res.sendStatus(403);

    jwt.verify(refreshToken, process.env.REFRESH_SECRET, async (err, payload) => {
      if (err) return res.sendStatus(403);

      const accessToken = generateAccessToken(payload.userId, payload.role);
      res.json({ accessToken });
    });
  } catch (err) {
    res.status(500).json({ message: "Error validating token" });
  }
};

const Logout= async (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  if (!refreshToken) return res.sendStatus(204); 

  await Token.deleteOne({ refreshToken });
  res.clearCookie("refreshToken").sendStatus(200);
};


export { registerTherapist, Login, registerPatient,refreshToken,Logout, registerAdmin }

