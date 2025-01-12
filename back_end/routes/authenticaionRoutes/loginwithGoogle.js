import express from "express";
import { authGoogle,googleCallback,getDashboard } from "../../controller/authentication/loginWithGoogle.js";
 

const router = express.Router();

router.get("/authgoogle", authGoogle)
router.get("/googlecallback", googleCallback)
router.get("/dashboard", getDashboard)

export default router;
