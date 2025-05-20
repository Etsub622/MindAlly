import express from "express";
import { registerPatient,registerTherapist,Login, refreshToken, Logout } from "../../controller/authentication/userAuth.js";

const router = express.Router()

router.post("/therapistSignup", registerTherapist)
router.post("/Login", Login)
router.post("/PatientSignup", registerPatient)
router.post("/refresh", refreshToken)
router.post("/logout", Logout)

export default router;