import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";
import { spawn } from 'child_process';
import bcrypt from "bcrypt";

// Create a new therapist
export const createTherapist = async (req, res) => {
  const { FullName, Email, Password, modality, Certificate, Bio, Fee, Rating, verified } = req.body;
  print(req.body);

  try {
    const existingTherapist = await Therapist.findOne({ Email });
    if (existingTherapist) return res.status(400).json({ message: "Email already exists" });

    const hashedPassword = await bcrypt.hash(Password, 10);

    const newTherapist = new Therapist({
      FullName,
      Email,
      Password: hashedPassword,
      modality,
      Certificate,
      Bio,
      Fee,
      Rating,
      verified,
    });

    print(newTherapist);

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

export const updateTherapist = async (req, res) => {
  const { FullName, Email, Password, modality, Bio, Fee, verified, gender, specialities, available_days, mode,language, experience_years} = req.body;

  console.log(req.body);

  try {
    const updates = {};
    if (Password) updates.Password = await bcrypt.hash(Password, 10);
    if (FullName) updates.FullName = FullName;
    if (Email) updates.Email = Email;
    if (modality) updates.modality = modality;
    if (Bio) updates.Bio = Bio;
    if (Fee) updates.Fee = Fee;
    if (verified !== undefined) if(verified) updates.verified = verified
    if(gender !== undefined) if(gender) updates.gender = gender;
    if(Array.isArray(specialities) && specialities.length > 0) if(specialities) updates.specialities = specialities;
    if (Array.isArray(available_days) && available_days.length > 0) updates.available_days = available_days;
    if(Array.isArray(mode) && mode.length > 0) if(mode) updates.mode = mode;
    if(Array.isArray(language) && language.length > 0) if(language) updates.language = language;
    if(experience_years !== undefined) if(experience_years) updates.experience_years = experience_years;
    
    console.log("update data: ", updates);
    const therapist = await Therapist.findByIdAndUpdate(req.params.therapist_id, updates);
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


// Inside getTopTherapists function, replace the Python call section with:
export const getTopTherapists = async (req, res) => {
  const { patient_id } = req.params;

  try {
    const user = await Patient.findById(patient_id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const therapists = await Therapist.find();

    const userData = {
      preferred_modality: user.preferred_modality || "",
      preferred_gender: user.preferred_gender || "",
      preferred_language: user.preferred_language || "",
      preferred_days: user.preferred_days || "",
      preferred_mode: user.preferred_mode || "",
      preferred_specialties: user.preferred_specialties || "",
      // age: user.age || 0
    };

    const therapistsData = therapists.map(t => ({
      _id: t._id.toString(),
      FullName: t.FullName,
      modality: t.modality || "",
      gender: t.gender || "",
      language: t.language || "",
      available_days: t.available_days || "",
      mode: t.mode || "",
      specialties: t.AreaofSpecification || "",
      experience_years: t.experience_years || 0
    }));

    const inputData = { user: userData, therapists: therapistsData };

    const pythonProcess = spawn('python3', ['therapist_matching/therapist_matcher.py']);
    let output = '';
    let errorOutput = '';

    pythonProcess.stdin.write(JSON.stringify(inputData) + '\n');
    pythonProcess.stdin.end();

    pythonProcess.stdout.on('data', (data) => {
      output += data.toString();
    });

    pythonProcess.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    const topTherapists = await new Promise((resolve, reject) => {
      pythonProcess.on('close', (code) => {
        if (code !== 0) {
          return reject(new Error(`Python process exited with code ${code}: ${errorOutput}`));
        }
        try {
          const result = JSON.parse(output);
          if (result.error) return reject(new Error(result.error));
          resolve(result);
        } catch (e) {
          reject(e);
        }
      });
    });

    const enrichedTherapists = topTherapists.map((t) => {
      const therapist = therapists.find(th => th._id.toString() === t.therapist_id.toString());


      return therapist
    });

    res.json({
      patient_id,
      top_therapists: enrichedTherapists
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};