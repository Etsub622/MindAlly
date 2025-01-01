const express = require('express');
const multer = require('multer');
const Joi = require('joi');
const Therapist = require('../models/Therapist');

const router = express.Router();

// Multer configuration for file uploads
const upload = multer({ dest: 'uploads/' });

// Validation middleware using Joi
const validateTherapistUpdate = (req, res, next) => {
  const schema = Joi.object({
    name: Joi.string().required(),
    email: Joi.string().email().required(),
    phone: Joi.string().optional(),
    qualifications: Joi.string().required(),
    specialization: Joi.string().required(),
    languages: Joi.array().items(Joi.string()).optional(),
    experience: Joi.number().required(),
    availability: Joi.array().items(
      Joi.object({
        day: Joi.string().required(),
        start_time: Joi.string().required(),
        end_time: Joi.string().required(),
      })
    ).optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Fetch therapist profile
router.get('/:therapist_id', async (req, res) => {
  try {
    const therapist = await Therapist.findOne({ therapist_id: req.params.therapist_id });
    if (!therapist) return res.status(404).json({ message: 'Therapist not found' });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update therapist profile
router.put('/:therapist_id', validateTherapistUpdate, async (req, res) => {
  const { name, email, phone, qualifications, specialization, languages, experience, availability } = req.body;
  try {
    const therapist = await Therapist.findOneAndUpdate(
      { therapist_id: req.params.therapist_id },
      { $set: { name, email, phone, qualifications, specialization, languages, experience, availability } },
      { new: true, runValidators: true }
    );
    if (!therapist) return res.status(404).json({ message: 'Therapist not found' });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Upload therapist profile picture
router.post('/:therapist_id/profile-picture', upload.single('picture'), async (req, res) => {
  try {
    const therapist = await Therapist.findOneAndUpdate(
      { therapist_id: req.params.therapist_id },
      { profile_picture: `/uploads/${req.file.filename}` },
      { new: true }
    );
    if (!therapist) return res.status(404).json({ message: 'Therapist not found' });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
