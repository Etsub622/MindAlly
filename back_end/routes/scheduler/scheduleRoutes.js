import express from 'express';
import {
  bookSession,
  getUserSessions,
  getUserSessionsByStatus,
  getTherapistSessions,
  getTherapistSessionsByStatus,
  confirmSession,
  completeSession,
  getSessionById,
  cancelSession
} from '../../controller/scheduler/scheduleController.js'

const router = express.Router();

router.post('/book', bookSession);
router.get('/user/:userId', getUserSessions);
router.get('/user/:userId/sessions', getUserSessionsByStatus);
router.get('/therapist/:therapistId', getTherapistSessions);
router.get('/therapist/:therapistId/sessions', getTherapistSessionsByStatus);
router.patch('/:sessionId/confirm', confirmSession);
router.patch('/:sessionId/complete', completeSession);
router.patch('/:sessionId/cancel', cancelSession);
router.get('/:sessionId', getSessionById);


export { router as scheduleRoutes };
