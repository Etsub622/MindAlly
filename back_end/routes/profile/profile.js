import express from "express";
import multer from "multer";
import bcrypt from "bcrypt"; // For hashing passwords
import Joi from "joi";
import { Patient } from "../../model/patientModel.js";

const router = express.Router();

// Multer configuration for file uploads
const upload = multer({ dest: "uploads/" });

// Validation middleware for patient updates using Joi
const validatePatientUpdate = (req, res, next) => {
  const schema = Joi.object({
    FullName: Joi.string().required(),
    Email: Joi.string().email().required(),
    Password: Joi.string().optional(),
    Collage: Joi.string().optional(),
    Role: Joi.string().optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Validation middleware for patient creation
const validatePatientCreation = (req, res, next) => {
  const schema = Joi.object({
    FullName: Joi.string().required(),
    Email: Joi.string().email().required(),
    Password: Joi.string().min(6).required(),
    Collage: Joi.string().optional(),
    Role: Joi.string().optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Fetch patient profile
router.get("/:patient_id", async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.patient_id);
    if (!patient) return res.status(404).json({ message: "Patient not found" });
    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create a new patient profile
router.post("/", validatePatientCreation, async (req, res) => {
  const { FullName, Email, Password, Collage, Role } = req.body;

  try {
    // Check if patient already exists
    const existingPatient = await Patient.findOne({ Email });
    if (existingPatient) return res.status(400).json({ message: "Email already exists" });

    // Hash the password
    const hashedPassword = await bcrypt.hash(Password, 10);

    // Create and save the patient
    const newPatient = new Patient({
      FullName,
      Email,
      Password: hashedPassword,
      Collage,
      Role,
    });

    await newPatient.save();
    res.status(201).json({ message: "Patient profile created successfully", newPatient });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update patient profile
router.put("/:patient_id", validatePatientUpdate, async (req, res) => {
  const { FullName, Email, Password, Collage, Role } = req.body;

  try {
    // Hash the password if it's being updated
    let updates = { FullName, Email, Collage, Role };
    if (Password) {
      updates.Password = await bcrypt.hash(Password, 10);
    }

    const patient = await Patient.findByIdAndUpdate(req.params.patient_id, updates, { new: true, runValidators: true });
    if (!patient) return res.status(404).json({ message: "Patient not found" });
    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Delete patient profile
router.delete("/:patient_id", async (req, res) => {
  try {
    const patient = await Patient.findByIdAndDelete(req.params.patient_id);
    if (!patient) return res.status(404).json({ message: "Patient not found" });
    res.json({ message: "Patient profile deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Upload patient profile picture
router.post("/:patient_id/profile-picture", upload.single("picture"), async (req, res) => {
  try {
    const patient = await Patient.findByIdAndUpdate(
      req.params.patient_id,
      { ProfilePicture: `/uploads/${req.file.filename}` },
      { new: true }
    );
    if (!patient) return res.status(404).json({ message: "Patient not found" });
    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

export default router;
