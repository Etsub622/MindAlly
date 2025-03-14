import Question from "../../model/Question.js";

export const createQuestion = async (req, res) => {
  try {
    const question = new Question(req.body);
    await question.save();
    res.status(201).json(question);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getQuestions = async (req, res) => {
  try {
    const questions = await Question.find();
    res.status(200).json(questions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getQuestionsByCategory = async (req, res) => {
    try {
      const { category } = req.params;
      const questions = await Question.find({ category: category });
      res.status(200).json(questions);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  