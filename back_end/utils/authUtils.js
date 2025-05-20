import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";


export const hashedPassword = async (password) => {
    if (!password) {
        throw new Error("Password is required");
    }

    const saltRounds = 10; 
    try {
        const salt = await bcrypt.genSalt(saltRounds); 
        return await bcrypt.hash(password, salt); 
    } catch (err) {
        throw new Error(`Error hashing password: ${err.message}`);
    }
};



export const generateAccessToken = (userId, role) => {
    return jwt.sign(
        { id: userId, role },

        process.env.ACCESS_SECRET,
        { expiresIn: "15m" }



    )
};


export const generateRefreshToken = (userId, role) => {
    return jwt.sign(
        { id: userId, role },
        process.env.REFRESH_SECRET,
        {expiresIn:"3d"}
    )
}

