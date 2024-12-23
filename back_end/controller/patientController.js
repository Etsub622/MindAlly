import bcrypt from "bcrypt";
import { Patient } from "../model/patientModel.js";


const registerPatient = async (req, res) => {
    try {

        const { fullName, email, password, confirmPassword, collage } = req.body
        
         if (password !== confirmPassword) {
            return res.status(400).json({ message: "Passwords do not match" });
        }
    
    const hashedPassword= await bcrypt.hash(password,10)
    
    const patient = new Patient({
      FullName:fullName,
      Email:email,
      Collage:collage,
      Password:hashedPassword
    })
    
        await patient.save()
        res.status(200).json(patient)
        
    } catch (error) {
        console.log(error)
        
    }
   
    
}

const patientLogin = async (req, res) => {
    try {
        const { Email, Password } = req.body;

       
        if (!Email || !Password) {
            return res.status(400).json({ error: "Email and Password are required." });
        }

        const patient = await Patient.findOne({ Email });
        if (!patient) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(Password, patient.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });
        }

        res.status(200).json({ message: "Login successful", Patient});
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

export {registerPatient,patientLogin}