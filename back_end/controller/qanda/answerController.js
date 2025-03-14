import Answer from "../../model/Answer.js";

export const createAnswer = async (req, res) => {
  try {
    const answer = new Answer(req.body);
    await answer.save();
    res.status(201).json(answer);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getAnswersByQuestion = async (req, res) => {
  try {
    const answers = await Answer.find({ questionId: req.params.id });
    res.status(200).json(answers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
