import { Session } from "../../model/sessionModel.js";
import { Therapist } from "../../model/therapistModel.js";



// Fetch therapist availability
export const getAvailableSlots = async (req, res) => {
  try {
    const { therapistId } = req.params;
    const therapist = await Therapist.findById(therapistId);
    if (!therapist) return res.status(404).json({ message: "Therapist not found" });

    res.status(200).json(therapist.availability);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Book a session & notify via WebSocket
export const bookSession = async (req, res) => {
  try {
    const { userId, therapistId, date, timeSlot } = req.body;

    const existingSession = await Session.findOne({ therapistId, date, timeSlot });
    if (existingSession) return res.status(400).json({ message: "Time slot already booked" });

    const session = new Session({ userId, therapistId, date, timeSlot });
    await session.save();



   

    res.status(201).json({ message: "Session booked successfully", session });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get user sessions
export const getUserSessions = async (req, res) => {
  try {
    const { userId } = req.params;
    const sessions = await Session.find({ userId }).populate("therapistId", "fullName specialization");
    res.status(200).json(sessions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getSessionById = async (req, res) => {
  try {
    const session = await Session.findById(req.params.sessionId);
    if (!session) {
      return res.status(404).json({ message: 'Session not found' });
    }
    res.json(session);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Cancel a session & notify via WebSocket
export const cancelSession = async (req, res) => {
  try {
    const { sessionId } = req.params;
    const session = await Session.findById(sessionId);
    if (!session) return res.status(404).json({ message: "Session not found" });

    session.status = "Cancelled";
    await session.save();

 

    res.status(200).json({ message: "Session cancelled", session });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getUserSessionsByStatus = async (req, res) => {
  const { status } = req.query;
  const filter = { userId: req.params.userId };
  if (status) filter.status = status;
  const sessions = await Session.find(filter);
  res.json(sessions);
};

export const getTherapistSessions = async (req, res) => {
  const sessions = await Session.find({ therapistId: req.params.therapistId });
  res.json(sessions);
};

export const getTherapistSessionsByStatus = async (req, res) => {
  const { status } = req.query;
  const filter = { therapistId: req.params.therapistId };
  if (status) filter.status = status;
  const sessions = await Session.find(filter);
  res.json(sessions);
};

export const confirmSession = async (req, res) => {
  const session = await Session.findByIdAndUpdate(req.params.sessionId, { status: 'confirmed' }, { new: true });
  if (!session) return res.status(404).send('Session not found');
  res.json(session);
};

export const completeSession = async (req, res) => {
  const session = await Session.findByIdAndUpdate(req.params.sessionId, { status: 'completed' }, { new: true });
  if (!session) return res.status(404).send('Session not found');
  res.json(session);
};

export const markCompletedAutomatically = async () => {
  const now = new Date();
  const formattedDate = now.toISOString().split('T')[0];
  const formattedTime = `${now.getHours()}:${now.getMinutes()}`;

  await Session.updateMany(
    { date: { $lt: formattedDate }, status: { $ne: 'completed' } },
    { status: 'completed' }
  );

  await Session.updateMany(
    { date: formattedDate, timeSlot: { $lte: formattedTime }, status: { $ne: 'completed' } },
    { status: 'completed' }
  );
};

setInterval(markCompletedAutomatically, 60000);
