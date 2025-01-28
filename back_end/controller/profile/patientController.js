import { Patient } from "../../model/patientModel.js";
import bcrypt from "bcrypt";

// Create a new patient
export const createPatient = async (req, res) => {
  const { FullName, Email, Password, Collage } = req.body;

  try {
    const existingPatient = await Patient.findOne({ Email });
    if (existingPatient) return res.status(400).json({ message: "Email already exists" });

    const hashedPassword = await bcrypt.hash(Password, 10);

    const newPatient = new Patient({
      FullName,
      Email,
      Password: hashedPassword,
      Collage,
    });

    await newPatient.save();
    res.status(201).json({ message: "Patient created successfully", newPatient });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Fetch a patient by ID
export const getPatient = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.patient_id);
    if (!patient) return res.status(404).json({ message: "Patient not found" });

    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Update a patient's details
export const updatePatient = async (req, res) => {
  const { FullName, Email, Password, Collage } = req.body;

  try {
    const updates = { FullName, Email, Collage };
    if (Password) updates.Password = await bcrypt.hash(Password, 10);

    const patient = await Patient.findByIdAndUpdate(req.params.patient_id, updates, { new: true });
    if (!patient) return res.status(404).json({ message: "Patient not found" });

    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Delete a patient by ID
export const deletePatient = async (req, res) => {
  try {
    const patient = await Patient.findByIdAndDelete(req.params.patient_id);
    if (!patient) return res.status(404).json({ message: "Patient not found" });

    res.json({ message: "Patient deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
