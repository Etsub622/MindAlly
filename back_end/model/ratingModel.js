import mongoose from "mongoose";


const ratingSchema = new mongoose.Schema({
    sessionId: { type: String, required: true },
    patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true },
    therapistId: { type: mongoose.Schema.Types.ObjectId, ref: 'Therapist', required: true },
    rating: { type: Number, required: true, min: 1, max: 5 },
    comment: { type: String, default: '' },
    createdAt: { type: Date, default: Date.now },
  });

  const Rating = mongoose.model("Rating", ratingSchema)
  
  export { Rating }