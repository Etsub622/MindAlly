import express from "express";
import { createQuestion, getQuestions, getQuestionsByCategory, getQuestionById, updateQuestion, deleteQuestion  } from "../../controller/qanda/questionController.js";

const router = express.Router();

router.post("/", createQuestion);
router.get("/", getQuestions);
router.get("/category/:category", getQuestionsByCategory);
router.get("/:id", getQuestionById);
router.put("/:id", updateQuestion); // Update Question
router.delete("/:id", deleteQuestion); // Delete Question

export default router;
