import { Session } from "../../model/sessionModel.js";
import { Therapist } from "../../model/therapistModel.js";
import { sendAppNotification } from '../../utils/notification.js';

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


export const bookSession = async (req, res) => {
  function convertTo24HourFormat(time12h) {
  const [time, modifier] = time12h.trim().toLowerCase().split(' ');
  let [hours, minutes] = time.split(':').map(str => parseInt(str));

  if (modifier === 'pm' && hours !== 12) hours += 12;
  if (modifier === 'am' && hours === 12) hours = 0;

  // Pad hours and minutes
  const h = String(hours).padStart(2, '0');
  const m = String(minutes).padStart(2, '0');
  return `${h}:${m}`;
}
  try {
    const { userId, therapistId, date, startTime, endTime, meeting_id, meeting_token } = req.body;

    // Validate required fields
    if (!userId || !therapistId || !date || !startTime || !endTime || !meeting_id || !meeting_token) {
      return res.status(400).json({ message: 'All fields are required.' });
    }

    // Enforce HH:mm 24-hour format
    const time12hRegex = /^((0?[1-9]|1[0-2]):[0-5][0-9]) ?(am|pm)$/i;
if (!time12hRegex.test(startTime) || !time12hRegex.test(endTime)) {
  return res.status(400).json({ message: "Time must be in 12-hour format (e.g., 9:00 am, 02:15 PM)" });
}


    // Convert to Date objects
    const parsedStart = convertTo24HourFormat(startTime);
const parsedEnd = convertTo24HourFormat(endTime);
const sessionStart = new Date(`${date}T${parsedStart}:00`);
const sessionEnd = new Date(`${date}T${parsedEnd}:00`);

    const now = new Date();

    if (isNaN(sessionStart) || isNaN(sessionEnd)) {
      return res.status(400).json({ message: "Invalid date or time." });
    }

    if (sessionStart <= now) {
      return res.status(400).json({ message: "Cannot schedule a session in the past." });
    }

    if (sessionEnd <= sessionStart) {
      return res.status(400).json({ message: "End time must be after start time." });
    }

    // Check for conflict with the same therapist at the same time (excluding completed/cancelled)
    const existingSession = await Session.findOne({
      therapistId,
      date,
      startTime,
      status: { $nin: ['Completed', 'Cancelled'] },
    });

    if (existingSession) {
      return res.status(400).json({ message: "This time slot is already booked." });
    }

    const session = new Session({ userId, therapistId, date, startTime, endTime, meeting_id, meeting_token });
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
    if (!session) {
      return res.status(404).json({ message: "Session not found" });
    }

    if (session.status === 'cancelled') {
      return res.status(400).json({ message: "Session is already cancelled." });
    }

    session.status = 'cancelled';
    await session.save();

    // // Optional: Notify both sides
    // sendAppNotification(session.userId, "Your session has been cancelled.");
    // sendAppNotification(session.therapistId, "A session has been cancelled.");

    res.status(200).json({ message: "Session cancelled successfully.", session });
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
  const session = await Session.findByIdAndUpdate(req.params.sessionId, { status: 'Confirmed' }, { new: true });
  if (!session) return res.status(404).send('Session not found');
  res.json(session);
};

export const completeSession = async (req, res) => {
  const session = await Session.findByIdAndUpdate(req.params.sessionId, { status: 'Completed' }, { new: true });
  if (!session) return res.status(404).send('Session not found');
  res.json(session);
};

// Reuse the same helper from your controller
function convertTo24HourFormat(time12h) {
  const [time, modifier] = time12h.trim().toLowerCase().split(' ');
  let [hours, minutes] = time.split(':').map(Number);

  if (modifier === 'pm' && hours !== 12) hours += 12;
  if (modifier === 'am' && hours === 12) hours = 0;

  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
}

export const markCompletedAutomatically = async () => {
  const now = new Date();
  const formattedDate = now.toISOString().split('T')[0];
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const nowTime24h = `${hours}:${minutes}`;

  // Step 1: Mark past-day sessions as completed
  await Session.updateMany(
    { date: { $lt: formattedDate }, status: { $ne: 'Completed' } },
    { status: 'Completed' }
  );

  // Step 2: Get today's sessions and mark if their endTime (converted) is <= now
  const todaysSessions = await Session.find({
    date: formattedDate,
    status: { $ne: 'Completed' }
  });

  for (const session of todaysSessions) {
    const endTimeConverted = convertTo24HourFormat(session.endTime);
    if (endTimeConverted <= nowTime24h) {
      session.status = 'Completed';
      await session.save();
    }
  }
};


export const autoCancelUnconfirmedSessions = async () => {
  const now = new Date();
  console.log(`[AUTO-CHECK] Running at ${now.toISOString()}`);

  const sessions = await Session.find({ status: 'Pending' });
  console.log(`[AUTO-CHECK] Found ${sessions.length} pending sessions`);

  for (const session of sessions) {
    const sessionStartString = `${session.date}T${convertTo24HourFormat(session.startTime)}:00`;
    const sessionDateTime = new Date(sessionStartString);
    const diffMs = sessionDateTime - now;
    const diffMins = Math.round(diffMs / 60000);

    console.log(`🕓 Session: ${session._id}, Starts: ${sessionStartString}, Diff: ${diffMins} mins`);

    if (diffMins <= 30) {
      session.status = 'Cancelled';
      await session.save();

      console.log(`❌ Session ${session._id} cancelled`);

      sendAppNotification(session.userId, "Your session was cancelled because it wasn't confirmed 30 minutes in advance.");
      sendAppNotification(session.therapistId, "A pending session was cancelled due to no confirmation.");
    }
  }
};


// Auto-run every 60s
setInterval(markCompletedAutomatically, 60000);

setInterval(autoCancelUnconfirmedSessions, 60000);


