import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import profileRoutes from './routes/profile/profile.js';
import therapistRoutes from './routes//profile/therapist.js';

dotenv.config();

const app = express();
app.use(bodyParser.json());

// Create uploads directory if it doesn't exist
const uploadsPath = path.resolve('uploads'); // Use `path.resolve` for ES modules
if (!fs.existsSync(uploadsPath)) {
  fs.mkdirSync(uploadsPath);
}

// Serve static files for uploaded images
app.use('/uploads', express.static(uploadsPath));

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error(err));


// Routes
app.use('/api/profile', profileRoutes);
app.use('/api/therapist', therapistRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
