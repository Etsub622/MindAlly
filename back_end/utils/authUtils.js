import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";


export const hashedPassword = async (password) => {
    return await bcrypt.hash(password, 10)
};




export const generateJWT = (userId, role) => {
    return jwt.sign(
        { id: userId, role },
        process.env.JWT_SECRET,
        { expiresIn: "1h" }
    )
};