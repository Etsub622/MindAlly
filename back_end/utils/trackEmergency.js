import cron from "node-cron";
import { Patient } from "../model/patientModel.js";
import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});


cron.schedule("*/2 * * * *", async () => {
  const fifteenDaysAgo = new Date(Date.now() - 15 * 24 * 60 * 60 * 1000);

  const inactivePatients = await Patient.find({
    lastLogin: { $lt: fifteenDaysAgo }
  });

for (const patient of inactivePatients) {
  if (patient.EmergencyEmail) {
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: patient.EmergencyEmail,
      subject: "MindAlly: Emergency Notification",
      text: `Hello,\n\nThis is an emergency notification. ${patient.FullName} has not logged in to MindAlly for over 10 minutes.`
    });
  } else {
    console.warn(`No EmergencyEmail for patient: ${patient.FullName} (${patient.Email})`);
  }
}
});