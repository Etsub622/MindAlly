import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import patientRoutes from "./routes/patientRoutes.js"
import therapistRoutes from "./routes/therapistRoutes.js"
import otpRoutes from "./routes/otpRoutes.js"
 


dotenv.config();
const app = express();
app.use(bodyParser.json());


mongoose
    .connect(process.env.Mongo_url)
    .then(() => {
        console.log("Database connected succesfully")
    })


app.use(cors({
 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
  credentials:true
}));

app.use("/api/patient",patientRoutes)
app.use("/api/therapist", therapistRoutes)
app.use("/api/otp",otpRoutes)


app.listen(process.env.PORT, () => {
    console.log(   `server is running on port ${process.env.PORT}`)
})

