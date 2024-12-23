import express from "express";
import { registerTherapist,therapistLogin } from "../controller/therapistController.js";

const router = express.Router()

router.post("/Tsignup", registerTherapist)
router.post("/Tlogin", therapistLogin)

export default router;