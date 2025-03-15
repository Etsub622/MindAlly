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

export const getAnswerById = async (req, res) => {
  try {
    const { id } = req.params;
    const answer = await Answer.findById(id);

    if (!answer) {
      return res.status(404).json({ message: "Answer not found" });
    }

    res.status(200).json(answer);
  } catch (error) {
    res.status(500).json({ message: "Error retrieving the answer", error: error.message });
  }
};
