import express from "express";
import multer from "multer";
import bcrypt from "bcrypt"; // For hashing passwords
import Joi from "joi";
import { Therapist } from "../../model/therapistModel.js";

const router = express.Router();

// Multer configuration for file uploads
const upload = multer({ dest: "uploads/" });

// Validation middleware for therapist updates using Joi
const validateTherapistUpdate = (req, res, next) => {
  const schema = Joi.object({
    FullName: Joi.string().required(),
    Email: Joi.string().email().required(),
    Password: Joi.string().optional(),
    AreaofSpecification: Joi.string().required(),
    Bio: Joi.string().optional(),
    Fee: Joi.number().optional(),
    Rating: Joi.number().optional(),
    Role: Joi.string().optional(),
    verified: Joi.boolean().optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Validation middleware for therapist profile creation
const validateTherapistCreation = (req, res, next) => {
  const schema = Joi.object({
    FullName: Joi.string().required(),
    Email: Joi.string().email().required(),
    Password: Joi.string().min(6).required(),
    AreaofSpecification: Joi.string().required(),
    Certificate: Joi.string().required(),
    Bio: Joi.string().optional(),
    Fee: Joi.number().optional(),
    Rating: Joi.number().optional(),
    Role: Joi.string().optional(),
    verified: Joi.boolean().optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Fetch therapist profile
router.get("/:therapist_id", async (req, res) => {
  try {
    const therapist = await Therapist.findById(req.params.therapist_id);
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create a new therapist profile
router.post("/", validateTherapistCreation, async (req, res) => {
  const { FullName, Email, Password, AreaofSpecification, Certificate, Bio, Fee, Rating, Role, verified } = req.body;

  try {
    // Check if therapist already exists
    const existingTherapist = await Therapist.findOne({ Email });
    if (existingTherapist) return res.status(400).json({ message: "Email already exists" });

    // Hash the password
    const hashedPassword = await bcrypt.hash(Password, 10);

    // Create and save the therapist
    const newTherapist = new Therapist({
      FullName,
      Email,
      Password: hashedPassword,
      AreaofSpecification,
      Certificate,
      Bio,
      Fee,
      Rating,
      Role,
      verified,
    });

    await newTherapist.save();
    res.status(201).json({ message: "Therapist profile created successfully", newTherapist });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update therapist profile
router.put("/:therapist_id", validateTherapistUpdate, async (req, res) => {
  const { FullName, Email, Password, AreaofSpecification, Bio, Fee, Rating, Role, verified } = req.body;

  try {
    // Hash the password if it's being updated
    let updates = { FullName, Email, AreaofSpecification, Bio, Fee, Rating, Role, verified };
    if (Password) {
      updates.Password = await bcrypt.hash(Password, 10);
    }

    const therapist = await Therapist.findByIdAndUpdate(req.params.therapist_id, updates, { new: true, runValidators: true });
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Delete therapist profile
router.delete("/:therapist_id", async (req, res) => {
  try {
    const therapist = await Therapist.findByIdAndDelete(req.params.therapist_id);
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });
    res.json({ message: "Therapist profile deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Upload therapist certificate
router.post("/:therapist_id/certificate", upload.single("certificate"), async (req, res) => {
  try {
    const therapist = await Therapist.findByIdAndUpdate(
      req.params.therapist_id,
      { Certificate: `/uploads/${req.file.filename}` },
      { new: true }
    );
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });
    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

export default router;
