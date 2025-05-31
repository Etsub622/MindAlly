import mongoose from "mongoose";

const sessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    therapistId: { type: mongoose.Schema.Types.ObjectId, ref: "Therapist", required: true },
    createrId: { type: String, required: true },
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
    patientCheckInTimes: [
      {
        index: { type: Number, required: true }, // Sequence number for the check-in
        time: { type: Date, required: true }, // Timestamp of the check-in
      },
    ],
    patientCheckOutTimes: [
      {
        index: { type: Number, required: true }, // Sequence number for the check-out
        time: { type: Date, required: true }, // Timestamp of the check-out
      },
    ],
    therapistCheckInTimes: [
      {
        index: { type: Number, required: true }, // Sequence number for the check-in
        time: { type: Date, required: true }, // Timestamp of the check-in
      },
    ],
    therapistCheckOutTimes: [
      {
        index: { type: Number, required: true }, // Sequence number for the check-out
        time: { type: Date, required: true }, // Timestamp of the check-out
      },
    ],
  },
  { timestamps: true }
);

export const Session = mongoose.model("Session", sessionSchema);