import mongoose from "mongoose";

const sessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    therapistId: { type: mongoose.Schema.Types.ObjectId, ref: "Therapist", required: true },
    date: { type: String, required: true }, // Format: YYYY-MM-DD
    timeSlot: { type: String, required: true }, // Example: "10:00 AM"
    status: {
      type: String,
      enum: ["Pending", "Confirmed", "Completed", "Cancelled"],
      default: "Pending",
    },
  },
  { timestamps: true }
);

export const Session = mongoose.model("Session", sessionSchema);
