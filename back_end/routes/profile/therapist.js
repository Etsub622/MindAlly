import express from "express";
import {
  createTherapist,
  getTherapist,
  updateTherapist,
  deleteTherapist,
} from "../../controller/profile/therapistController.js";

const router = express.Router();

router.post("/", createTherapist);
router.get("/:therapist_id", getTherapist);
router.put("/:therapist_id", updateTherapist);
router.delete("/:therapist_id", deleteTherapist);

export default router;
