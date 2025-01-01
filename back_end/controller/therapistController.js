import bcrypt from "bcrypt"
import { Therapist } from "../model/therapistModel.js";
import { generateJWT, hashedPassword } from "../utils/authUtils.js";


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

const therapistLogin = async (req, res) => {
    try {
        const { email, password } = req.body;

       
        if (!email || !password) {
            return res.status(400).json({ error: "Email and Password are required." });
        }

        const therapist = await Therapist.findOne({ Email:email });
        if (!therapist) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(password, therapist.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });
        }

    const token = generateJWT(therapist._id, therapist.Role);

    res.status(200).json({ message: "Therapist login successful", token, user: therapist });  
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

export {registerTherapist,therapistLogin}