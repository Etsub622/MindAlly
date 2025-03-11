import express from "express";
import { createAnswer, getAnswersByQuestion } from "../../controller/qanda/answerController.js";

const router = express.Router();

router.post("/", createAnswer);
router.get("/:id", getAnswersByQuestion);

export default router;
