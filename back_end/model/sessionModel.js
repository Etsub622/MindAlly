import mongoose from "mongoose";

const sessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    therapistId: { type: mongoose.Schema.Types.ObjectId, ref: "Therapist", required: true },
    date: { type: String, required: true }, // Format: YYYY-MM-DD
    startTime: { type: String, required: true },
    endTime: { type: String, required: true },
    status: {
      type: String,
      enum: ["Pending", "Confirmed", "Completed", "Cancelled"],
      default: "Pending",
    },
    meeting_token: { type: String, required: true },
    meeting_id: { type: String, required: true },

    // ✅ New field to track time user was inside session
    timeTracks: [
      {
        joinedAt: { type: Date },
        leftAt: { type: Date },
      },
    ],
  },
  { timestamps: true }
);


export const Session = mongoose.model("Session", sessionSchema);
