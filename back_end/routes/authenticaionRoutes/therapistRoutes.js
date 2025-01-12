import express from "express";
import { registerTherapist,therapistLogin } from "../../controller/authentication/therapistController.js";

const router = express.Router()

router.post("/therapistSignup", registerTherapist)
router.post("/therapistLogin", therapistLogin)

export default router;