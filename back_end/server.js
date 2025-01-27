import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import patientRoutes from "./routes/profile/profile.js";
import therapistRoutes from "./routes/profile/therapist.js";

dotenv.config();

const app = express();
app.use(express.json());

// Create uploads directory if it doesn't exist
import fs from "fs";
import path from "path";
const uploadsPath = path.resolve("uploads");
if (!fs.existsSync(uploadsPath)) {
  fs.mkdirSync(uploadsPath);
}
app.use("/uploads", express.static(uploadsPath));

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error(err));

// Routes
app.use("/api/patients", patientRoutes);
app.use("/api/therapists", therapistRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
