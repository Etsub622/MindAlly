import express from "express";
import { registerPatient,registerTherapist,Login } from "../../controller/authentication/userAuth.js";

const router = express.Router()

router.post("/therapistSignup", registerTherapist)
router.post("/Login", Login)
router.post("/PatientSignup",registerPatient )

export default router;