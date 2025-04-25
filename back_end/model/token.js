import mongoose from "mongoose";

const tokenSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    refPath: "userModel"
  },
  userModel: {
    type: String,
    required: true,
    enum: ["Patient", "Therapist"]
  },
  refreshToken: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: "7d" // optional auto cleanup
  }
});

const Token = mongoose.model("Token", tokenSchema);
export { Token };

