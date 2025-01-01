import bcrypt from "bcrypt";
import { Patient } from "../model/patientModel.js";
import { hashedPassword,generateJWT } from "../utils/authUtils.js";


const registerPatient = async (req, res) => {
    try {

        const { fullName, email, password, collage } = req.body
        
        const hashpass=await hashedPassword(password)
    
  
    
    const patient = new Patient({
      FullName:fullName,
      Email:email,
      Collage:collage,
    Password: hashpass,
      Role:"patient"
    })
    
        await patient.save()
        const token = generateJWT(patient._id,patient.Role)
        
        res.status(200).json({
            message: "patient login successful",
            token,
            user:patient,
        })
        
    } catch (error) {
        console.log(error)
        
    }
   
    
}

const patientLogin = async (req, res) => {
    try {
        const { email, password } = req.body;

       
        if (!email || !password) {
            return res.status(400).json({ error: "Email and Password are required." });
        }

        const patient = await Patient.findOne({ Email:email});
        if (!patient) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(password, patient.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });
        }
        const token =generateJWT(patient._id,patient.Role)

        res.status(200).json({ message: "login successful", token ,user:patient});
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

export {registerPatient,patientLogin}