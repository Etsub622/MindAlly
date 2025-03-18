import express from "express";
import { createAnswer, getAnswersByQuestion, getAnswerById, updateAnswer, deleteAnswer } from "../../controller/qanda/answerController.js";

const router = express.Router();

router.post("/", createAnswer);
router.get("/:id", getAnswersByQuestion);
router.get("/answer/:id", getAnswerById);
router.put("/:id", updateAnswer); 
router.delete("/:id", deleteAnswer); 

export default router;
