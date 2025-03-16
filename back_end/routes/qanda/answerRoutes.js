import express from "express";
import { createAnswer, getAnswersByQuestion, getAnswerById } from "../../controller/qanda/answerController.js";

const router = express.Router();

router.post("/", createAnswer);
router.get("/:id", getAnswersByQuestion);
router.get("/answer/:id", getAnswerById);

export default router;
