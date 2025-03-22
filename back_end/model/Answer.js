import mongoose from "mongoose";

const answerSchema = new mongoose.Schema({
  answer: { type: String, required: true },
  therapistName: { type: String, required: true },
  therapistProfile: { type: String, required: true },
  questionId: { type: mongoose.Schema.Types.ObjectId, ref: "Question", required: true },
},
{ timestamps: true });

const Answer = mongoose.model("Answer", answerSchema);

export default Answer;
