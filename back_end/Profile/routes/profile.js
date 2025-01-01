const express = require('express');
const multer = require('multer');
const Joi = require('joi');
const User = require('../models/User');

const router = express.Router();

// Multer configuration for file uploads
const upload = multer({ dest: 'uploads/' });

// Validation middleware using Joi
const validateProfileUpdate = (req, res, next) => {
  const schema = Joi.object({
    name: Joi.string().required(),
    email: Joi.string().email().required(),
    phone: Joi.string().optional(),
    preferences: Joi.object({
      therapist_gender: Joi.string().valid('male', 'female', 'any'),
      language: Joi.string(),
    }).optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Fetch user profile
router.get('/:user_id', async (req, res) => {
  try {
    const user = await User.findOne({ user_id: req.params.user_id });
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update user profile
router.put('/:user_id', validateProfileUpdate, async (req, res) => {
  const { name, email, phone, preferences } = req.body;
  try {
    const user = await User.findOneAndUpdate(
      { user_id: req.params.user_id },
      { $set: { name, email, phone, preferences } },
      { new: true, runValidators: true }
    );
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Upload profile picture
router.post('/:user_id/profile-picture', upload.single('picture'), async (req, res) => {
  try {
    const user = await User.findOneAndUpdate(
      { user_id: req.params.user_id },
      { profile_picture: `/uploads/${req.file.filename}` },
      { new: true }
    );
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update notification preferences
router.put('/:user_id/notifications', async (req, res) => {
  const { notifications } = req.body;
  try {
    const user = await User.findOneAndUpdate(
      { user_id: req.params.user_id },
      { 'preferences.notifications': notifications },
      { new: true }
    );
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
