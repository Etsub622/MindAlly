import express from "express";
import {
  createPatient,
  getPatient,
  updatePatient,
  deletePatient,
} from "../../controller/profile/patientController.js";

const router = express.Router();

router.post("/", createPatient);
router.get("/:patient_id", getPatient);
router.put("/:patient_id", updatePatient);
router.delete("/:patient_id", deletePatient);

export default router;
