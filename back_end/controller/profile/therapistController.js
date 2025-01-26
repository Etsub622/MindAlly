import { Therapist } from "../../model/therapistModel.js";
import bcrypt from "bcrypt";

// Create a new therapist
export const createTherapist = async (req, res) => {
  const { FullName, Email, Password, AreaofSpecification, Certificate, Bio, Fee, Rating, verified } = req.body;

  try {
    const existingTherapist = await Therapist.findOne({ Email });
    if (existingTherapist) return res.status(400).json({ message: "Email already exists" });

    const hashedPassword = await bcrypt.hash(Password, 10);

    const newTherapist = new Therapist({
      FullName,
      Email,
      Password: hashedPassword,
      AreaofSpecification,
      Certificate,
      Bio,
      Fee,
      Rating,
      verified,
    });

    await newTherapist.save();
    res.status(201).json({ message: "Therapist created successfully", newTherapist });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Fetch a therapist by ID
export const getTherapist = async (req, res) => {
  try {
    const therapist = await Therapist.findById(req.params.therapist_id);
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });

    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Update a therapist's details
export const updateTherapist = async (req, res) => {
  const { FullName, Email, Password, AreaofSpecification, Bio, Fee, Rating, verified } = req.body;

  try {
    const updates = { FullName, Email, AreaofSpecification, Bio, Fee, Rating, verified };
    if (Password) updates.Password = await bcrypt.hash(Password, 10);

    const therapist = await Therapist.findByIdAndUpdate(req.params.therapist_id, updates, { new: true });
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });

    res.json(therapist);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Delete a therapist by ID
export const deleteTherapist = async (req, res) => {
  try {
    const therapist = await Therapist.findByIdAndDelete(req.params.therapist_id);
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });

    res.json({ message: "Therapist deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
