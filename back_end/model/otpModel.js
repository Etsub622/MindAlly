import mongoose from "mongoose";

const otpSchema = new mongoose.Schema({
  email: {
    type:String
  },
    otp: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    expiresAt: {
        type: Date,
        required: true, // Marked as required
    },
});


const Otp = mongoose.model("Otp",otpSchema)


export{Otp}