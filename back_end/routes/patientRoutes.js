import express from "express";
import { registerPatient,patientLogin } from "../controller/patientController.js";

const router = express.Router()

router.post("/Psignup",registerPatient )
router.post("/Plogin",patientLogin )

export default router;