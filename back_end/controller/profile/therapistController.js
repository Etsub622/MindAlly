import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";
import { ChatHistory } from "../../model/chatsModel.js";
import { spawn } from 'child_process';
import bcrypt from "bcrypt";

import { sendEmail } from '../../utils/sendEmail.js';

import { promises as fs } from 'fs'; // For async file operations
import { tmpdir } from 'os'; // Import tmpdir
import { join } from 'path'; // Import join explicitly


// Create a new therapist
export const createTherapist = async (req, res) => {
  const { FullName, Email, Password, modality, Certificate, Bio, Fee, Rating, verified } = req.body;
  // print(req.body);
  console.log(req.body);

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

    // print(newTherapist);
    console.log(newTherapist);

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
  const { FullName, Email, Password, modality, Bio, Fee, verified, gender, specialities, available_days, mode,language, experience_years, payout} = req.body;

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
    if (payout && payout.account_number && payout.account_name && payout.bank_code) {
      updates.payout = {
        account_number: payout.account_number,
        account_name: payout.account_name,
        bank_code: payout.bank_code,
      };
    }
    
    console.log("update data: ", updates);
    const therapist = await Therapist.findByIdAndUpdate(req.params.therapist_id, updates);
    console.log("updated therapist: ", therapist);
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

export const getTopTherapists = async (req, res) => {
  const { patient_id } = req.params;

  try {
    const user = await Patient.findById(patient_id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const therapists = await Therapist.find();

    const userData = {
      preferred_modality: user.preferred_modality || "",
      preferred_gender: user.preferred_gender || "",
      preferred_language: Array.isArray(user.preferred_language) ? user.preferred_language : (user.preferred_language || []),
      preferred_days: Array.isArray(user.preferred_days) ? user.preferred_days : (user.preferred_days || []),
      preferred_mode: user.preferred_mode || "",
      preferred_specialties: Array.isArray(user.preferred_specialties) ? user.preferred_specialties : (user.preferred_specialties || []),
    };

    const therapistsData = therapists
      .filter(t => t.Role !== "pending_therapist")
      .map(t => ({
        _id: t._id.toString(),
        FullName: t.FullName,
        modality: t.modality || "",
        gender: t.gender || "",
        language: Array.isArray(t.language) ? t.language : (t.language || []),
        available_days: Array.isArray(t.available_days) ? t.available_days.join(',') : (t.available_days || ""),
        mode: Array.isArray(t.mode) ? t.mode : (t.mode || []),
        AreaofSpecification: Array.isArray(t.specialities) ? t.specialities.join(',') : (t.specialities || ""),
        experience_years: t.experience_years || 0
      }));

    const inputData = { user: userData, therapists: therapistsData };

    // Create a temporary file for Python output
    const tempFile = join(tmpdir(), `therapist_match_${Date.now()}.json`);

    const pythonProcess = spawn('python', ['therapist_matching/therapist_matcher.py', tempFile]);
    let errorOutput = '';

    pythonProcess.stdin.write(JSON.stringify(inputData) + '\n');
    pythonProcess.stdin.end();

    pythonProcess.stderr.on('data', (data) => {
      errorOutput += data.toString();
      console.log("Python error output:", data.toString());
    });

    const topTherapists = await new Promise((resolve, reject) => {
      pythonProcess.on('close', async (code) => {
        if (code !== 0) {
          console.log(`Python process exited with code ${code}: ${errorOutput}`);
          return reject(new Error(`Python process exited with code ${code}: ${errorOutput}`));
        }
        try {
          // Read the result from the temporary file
          const output = await fs.readFile(tempFile, 'utf8');
          const result = JSON.parse(output);
          if (result.error) return reject(new Error(result.error));
          resolve(result);
        } catch (e) {
          console.error("Error reading or parsing temp file:", e.message);
          reject(e);
        } finally {
          // Clean up the temporary file
          fs.unlink(tempFile).catch(err => console.error("Failed to delete temp file:", err));
        }
      });
    });

    const enrichedTherapists = await Promise.all(topTherapists.map(async (t) => {
      const therapist = therapists.find(th => th._id.toString() === t.therapist_id.toString());
      const existingChat = await ChatHistory.findOne({
        $or: [
          { senderId: patient_id, receiverId: t.therapist_id },
          { senderId: t.therapist_id, receiverId: patient_id }
        ]
      });
      return {
        ...therapist.toObject(),
        chatId: existingChat ? existingChat.chatId : null
      };
    }));

    res.json({
      patient_id,
      top_therapists: enrichedTherapists
    });
  } catch (err) {
    console.error("Error in getTopTherapists:", err);
    res.status(500).json({ message: err.message });
  }
};

// Get all therapists whose documents are not approved (Role: "pending_therapist")
export const getUnapprovedTherapists = async (req, res) => {
  try {
    const unapprovedTherapists = await Therapist.find({ Role: 'pending_therapist' })
      .select('_id FullName Email Role Certificate modality')
      .lean();
    res.json(unapprovedTherapists);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch unapproved therapists', error: err.message });
  }
};

// Get all therapists whose documents are approved (Role: "therapist")
export const getApprovedTherapists = async (req, res) => {
  try {
    const approvedTherapists = await Therapist.find({
      Role: "therapist"
    });

    res.json(approvedTherapists);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


export const approveTherapist = async (req, res) => {
  try {
    const therapist = await Therapist.findById(req.params.therapist_id);
    if (!therapist) {
      return res.status(404).json({ message: "Therapist not found" });
    }
    therapist.Role = "therapist";
    therapist.verified = true; 
    await therapist.save();

    // Send congratulatory email
    if (therapist.Email) {
      await sendEmail(
        therapist.Email,
        "Congratulations! Your therapist profile is approved",
        `<div style="text-align:center;">
          <img src="https://cdn.pixabay.com/photo/2017/01/31/13/14/award-2025795_1280.png" alt="Congratulations" width="120" />
          <h2>Congratulations, ${therapist.FullName}!</h2>
          <p>Your therapist application has been <b>approved</b>.<br>
          You can now access all professional features on MindAlly.</p>
        </div>`
      );
    }

    res.json({ message: "Therapist approved successfully", therapist });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export const getRejectedTherapists = async (req, res) => {
  try {
    const rejectedTherapists = await Therapist.find({ Role: 'rejected_therapist' })
      .select('_id FullName Email Role Certificate modality rejectionReason')
      .lean();
    res.json(rejectedTherapists);
  } catch (err) {
    res.status(500).json({ message: 'Failed to fetch rejected therapists', error: err.message });
  }
};


export const rejectTherapist = async (req, res) => {
  try {
    const therapist = await Therapist.findById(req.params.therapist_id);
    if (!therapist) {
      return res.status(404).json({ message: "Therapist not found" });
    }
    // Store rejection reason
    if (req.body.reason) {
      therapist.rejectionReason = req.body.reason;
    }
    therapist.verified = false;
    therapist.Role = "rejected_therapist";
    await therapist.save();

    // Send email notification to therapist
    if (therapist.Email && therapist.rejectionReason) {
      await sendEmail(
        therapist.Email,
        "Your therapist application was rejected",
        `<p>Dear ${therapist.FullName},<br>Your application was rejected for the following reason:<br><b>${therapist.rejectionReason}</b></p>`
      );
    }

    res.json({ message: "Therapist rejected successfully", therapist });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};