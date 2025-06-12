import cron from "node-cron";
import { Patient } from "../model/patientModel.js";
import nodemailer from "nodemailer";

// Set up your email transporter (use your real credentials)
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER, // your email
    pass: process.env.EMAIL_PASS, // your password or app password
  },
});

// Run every day at 8:00 AM
cron.schedule("*/2 * * * *", async () => {
  const fiveDaysAgo = new Date(Date.now() - 5 * 24 * 60 * 60 * 1000); // 5 days ago

  const inactivePatients = await Patient.find({
    lastLogin: { $lt: fiveDaysAgo }
  });

  for (const patient of inactivePatients) {
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: patient.Email,
      subject: "We miss you at MindAlly!",
      text: `Hi ${patient.FullName},\n\nIt's been a while since you last logged in. We hope to see you back soon!`
    });
    // Optionally, update a flag so you don't email them again
  }
});