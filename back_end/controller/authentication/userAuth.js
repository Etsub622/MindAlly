import bcrypt from "bcrypt"
import { Therapist } from "../../model/therapistModel.js";
import { Patient } from "../../model/patientModel.js";
import { generateJWT, hashedPassword } from "../../utils/authUtils.js";


const registerTherapist = async (req, res) => {
    try {

        const { fullName, email, password, specialization , certificate} = req.body
        
    
    const hashedPass= await hashedPassword(password)
    
    const therapist = new Therapist({
      FullName:fullName,
      Email:email,
      AreaofSpecification:specialization,
      Password: hashedPass,
      Certificate: certificate,
      Role: "therapist",
      verified:false
      
    })
    
        await therapist.save()
        const token =generateJWT(therapist._id ,therapist.Role)
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
            message: "patient signup successful",
            token,
            user:patient,
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

           const userModel = await Patient.findOne({ Email: email }) || await Therapist.findOne({ Email:email });
        if (!userModel) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(password, userModel.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });
        }

    const token = generateJWT(userModel._id, userModel.Role);

    res.status(200).json({ message: "user login successful", token, user:userModel });  
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

export {registerTherapist,Login,registerPatient}