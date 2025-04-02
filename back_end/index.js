import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import userRoutes from "./routes/authenticaionRoutes/userAuth.js"
import otpRoutes from "./routes/authenticaionRoutes/otpRoutes.js"
// import googleRoutes from "./routes/authenticaionRoutes/loginwithGoogle.js"
import patientRoutes from "./routes/profile/profile.js";
import therapistRoutes from "./routes/profile/therapist.js";
import paymentRoutes from "./routes/Payment/pay.js"

 


dotenv.config();
const app = express();
app.use(bodyParser.json());


mongoose
    .connect(process.env.Mongo_url)
    .then(() => {
        console.log("Database connected succesfully")
    })



app.get('/', (req, res) => {
    res.send("I am working properly")
})


app.use(cors({
 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
  credentials:true
}));


app.use("/api/user", userRoutes)
app.use("/api/otp", otpRoutes)
// app.use("/api/google",googleRoutes)

app.use("/api/patients", patientRoutes);
app.use("/api/therapists", therapistRoutes);
app.use("/api/Payment",paymentRoutes)

app.listen(process.env.PORT, () => {
    console.log(   `server is running on port ${process.env.PORT}`)
})

