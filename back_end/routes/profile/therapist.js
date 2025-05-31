import express from "express";
import {
  createTherapist,
  getTherapist,
  updateTherapist,
  deleteTherapist,
  getTopTherapists,
  getUnapprovedTherapists,
} from "../../controller/profile/therapistController.js";
import { verifyToken } from "../../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/", createTherapist);
router.get("/unapproved", getUnapprovedTherapists);
router.get("/:therapist_id", getTherapist);
router.put("/:therapist_id", verifyToken, updateTherapist);
router.delete("/:therapist_id", verifyToken, deleteTherapist);
router.get("/top/:patient_id", verifyToken, getTopTherapists);

export default router;
