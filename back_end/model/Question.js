import mongoose from "mongoose";

const questionSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  studentName: { type: String, required: true },
  studentProfile: { type: String, required: true },
  category: { type: [String], required: true },
},
{ timestamps: true });

const Question = mongoose.model("Question", questionSchema);

export default Question;
