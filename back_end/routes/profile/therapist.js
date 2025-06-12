import express from "express";
import {
  createTherapist,
  getTherapist,
  updateTherapist,
  deleteTherapist,
  getTopTherapists,
  getUnapprovedTherapists,
  getApprovedTherapists,
  approveTherapist,
  rejectTherapist,
  getRejectedTherapists
} from "../../controller/profile/therapistController.js";
import { verifyToken } from "../../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/", createTherapist);
router.get("/unapproved", getUnapprovedTherapists);
router.get("/approvedTherapists", getApprovedTherapists)
router.get('/therapists/rejected', getRejectedTherapists);
router.get("/:therapist_id", getTherapist);

router.put("/:therapist_id", verifyToken, updateTherapist);
router.delete("/:therapist_id", verifyToken, deleteTherapist);
router.get("/top/:patient_id", verifyToken, getTopTherapists);
router.put('/:therapist_id/approve', approveTherapist);
router.post('/:therapist_id/reject', rejectTherapist);


export default router;
