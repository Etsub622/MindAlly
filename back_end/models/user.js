const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  user_id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true }, // Ensure this is hashed
  phone: { type: String },
  profile_picture: { type: String }, // URL for profile picture
  preferences: {
    therapist_gender: { type: String, enum: ['male', 'female', 'any'] },
    language: { type: String },
    notifications: {
      session_reminders: { type: Boolean, default: true },
      resource_updates: { type: Boolean, default: true },
    },
  },
});

module.exports = mongoose.model('User', UserSchema);
