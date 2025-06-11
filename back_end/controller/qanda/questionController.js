import Question from "../../model/Question.js";

export const createQuestion = async (req, res) => {
  try {
    const question = new Question(req.body);
    console.log(req.body);
    await question.save();
    res.status(201).json(question);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getQuestions = async (req, res) => {
  try {
    const questions = await Question.find().sort({ createdAt: -1 });
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

  export const getQuestionById = async (req,res) => {
    try {
      const { id } = req.params;
      const question = await Question.findById(id);

      if (!question) {
        return res.status(404).json({ message: "Question not found" });
      }

      res.status(200).json(question);
    } catch (error) {
      res.status(500).json({ message: "Error retrieving the question", error: error.message });
    }
  };

  export const updateQuestion = async (req, res) => {
    try {
      const { id } = req.params;
      const updatedQuestion = await Question.findByIdAndUpdate(id, req.body, { new: true });
  
      if (!updatedQuestion) {
        return res.status(404).json({ message: "Question not found" });
      }
  
      res.status(200).json(updatedQuestion);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  
  export const deleteQuestion = async (req, res) => {
    try {
      const { id } = req.params;
      const deletedQuestion = await Question.findByIdAndDelete(id);
  
      if (!deletedQuestion) {
        return res.status(404).json({ message: "Question not found" });
      }
  
      res.status(200).json({ message: "Question deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  
  