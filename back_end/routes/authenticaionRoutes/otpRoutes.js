import express from "express";
import { sendOTPverification ,verifyOTP} from "../../controller/authentication/optController.js";
import { forgotPassword, resetPassword, verifyPasswordResetOTP } from "../../controller/authentication/resetpassword.js";
const router = express.Router()

router.post("/sendOTP",sendOTPverification )
router.post("/verifyOTP", verifyOTP)
router.post("/resetPassword", resetPassword)
router.post("/verifyReset", verifyPasswordResetOTP)
router.post("/forgotPassword",forgotPassword)

export default router;