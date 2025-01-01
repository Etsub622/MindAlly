import express from "express";
import { sendOTPverification ,verifyOTP} from "../controller/optController.js";

const router = express.Router()

router.post("/sendOTP",sendOTPverification )
router.post("/verifyOTP",verifyOTP )

export default router;