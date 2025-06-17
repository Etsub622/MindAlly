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
      EmergencyEmail,
    });
    console.log(newPatient);

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
   console.log(patient);
    res.json(patient);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Update a patient's details (including onboarding data)
export const updatePatient = async (req, res) => {
  const { 
    FullName, 
    Email, 
    Password, 
    Collage,
    gender,
    preferred_modality,
    preferred_gender,
    preferred_language,
    preferred_days,
    preferred_mode,
    preferred_specialties,
    payout,
    profilePicture,
  } = req.body;
  console.log(req.body);
  try {
    const updates = {};
    
    if (FullName) updates.FullName = FullName;
    if (Email) updates.Email = Email;
    if (Collage) updates.Collage = Collage;
    if (Password) updates.Password = await bcrypt.hash(Password, 10);
    if(profilePicture) updates.profilePicture = profilePicture;
    console.log("dfghjklfghj",  updates.profilePicture, profilePicture);
    if (gender !== undefined) if(gender) updates.gender = gender;
    if (preferred_modality !== undefined) if(preferred_modality) updates.preferred_modality = preferred;
    if (preferred_gender !== undefined)  if(preferred_gender) updates.preferred_gender = preferred_gender;
    if (preferred_language !== undefined) if(preferred_language) updates.preferred_language = preferred_language;
    if (preferred_days !== undefined) if(preferred_days) updates.preferred_days = preferred_days;
    if (preferred_mode !== undefined) if(preferred_mode) updates.preferred_mode = preferred_mode;
    if (preferred_specialties !== undefined) if(preferred_specialties) updates.preferred_specialties = preferred_specialties;
    if (payout && payout.account_number && payout.account_name && payout.bank_code) {
      updates.payout = {
        account_number: payout.account_number,
        account_name: payout.account_name,
        bank_code: payout.bank_code,
      };
    }

    const patient = await Patient.findByIdAndUpdate(
      req.params.patient_id, 
      updates, 
      { 
        new:true,
        runValidators: true
      }
    );

    if (!patient) return res.status(404).json({ message: "Patient not found" });
    
    res.json({
      message: "Patient updated successfully",
      patient
    });
    console.log(patient);
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
