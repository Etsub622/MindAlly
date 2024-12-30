import express from "express";
import { registerPatient,patientLogin } from "../controller/patientController.js";

const router = express.Router()

router.post("/PatientSignup",registerPatient )
router.post("/patientLogin",patientLogin )

export default router;