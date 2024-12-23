import bcrypt from "bcrypt";
import { Therapist } from "../model/therapistModel.js";


const registerTherapist = async (req, res) => {
    try {

        const { fullName, email, password, specialization , certificate} = req.body
        
    
    const hashedPassword= await bcrypt.hash(password,10)
    
    const therapist = new Therapist({
      FullName:fullName,
      Email:email,
      AreaofSpecification:specialization,
      Password: hashedPassword,
      Certificate:certificate
    })
    
        await therapist.save()
        res.status(200).json(therapist)
        
    } catch (error) {
        console.log(error)
        
    }
   
    
}

const therapistLogin = async (req, res) => {
    try {
        const { Email, Password } = req.body;

       
        if (!Email || !Password) {
            return res.status(400).json({ error: "Email and Password are required." });
        }

        const therapist = await Therapist.findOne({ Email });
        if (!therapist) {
            return res.status(404).json({ error: "Invalid email or password." });
        }

     
        const isMatch = await bcrypt.compare(Password, therapist.Password);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password." });
        }

        res.status(200).json({ message: "Login successful", Therapist});
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "An error occurred during login." });
    }
};

export {registerTherapist,therapistLogin}