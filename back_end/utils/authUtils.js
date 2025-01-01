import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";


export const hashedPassword = async (password) => {
    if (!password) {
        throw new Error("Password is required");
    }

    const saltRounds = 10; // Number of rounds for salt generation
    try {
        const salt = await bcrypt.genSalt(saltRounds); // Generate a salt
        return await bcrypt.hash(password, salt); // Hash the password using the salt
    } catch (err) {
        throw new Error(`Error hashing password: ${err.message}`);
    }
};



export const generateJWT = (userId, role) => {
    return jwt.sign(
        { id: userId, role },
        process.env.JWT_SECRET,
        { expiresIn: "1h" }
    )
};