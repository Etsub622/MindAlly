const mongoose = require('mongoose');

const TherapistSchema = new mongoose.Schema({
  therapist_id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true }, // Ensure hashed storage
  phone: { type: String },
  profile_picture: { type: String },
  qualifications: { type: String, required: true },
  specialization: { type: String, required: true },
  languages: [{ type: String }], // Array of supported languages
  experience: { type: Number, required: true }, // Years of experience
  ratings: { type: Number, default: 0 }, // Average ratings
  availability: {
    type: [{ day: String, start_time: String, end_time: String }],
    default: [], // Array of available time slots
  },
});

module.exports = mongoose.model('Therapist', TherapistSchema);
