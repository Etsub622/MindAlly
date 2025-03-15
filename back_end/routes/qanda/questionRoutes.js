import express from "express";
import { createQuestion, getQuestions, getQuestionsByCategory, getQuestionById  } from "../../controller/qanda/questionController.js";

const router = express.Router();

router.post("/", createQuestion);
router.get("/", getQuestions);
router.get("/category/:category", getQuestionsByCategory);
router.get("/:id", getQuestionById);

export default router;
