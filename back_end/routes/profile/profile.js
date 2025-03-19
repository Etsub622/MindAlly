import express from "express";
import { verifyToken } from "../../middlewares/authMiddleware.js";
import {
  createPatient,
  getPatient,
  updatePatient,
  deletePatient,
} from "../../controller/profile/patientController.js";

const router = express.Router();

router.post("/", createPatient);
router.get("/:patient_id", getPatient);
router.put("/:patient_id", verifyToken, updatePatient);
router.delete("/:patient_id", verifyToken, deletePatient);

export default router;
