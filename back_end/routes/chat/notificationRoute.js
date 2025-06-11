import express from "express";
import {
    sendUserNotification,
    saveFCMToken
} from "../../controller/chat/notificationController.js";
import { verifyToken } from "../../middlewares/authMiddleware.js";

const router = express.Router();
router.post("/save-token", verifyToken, saveFCMToken);
router.post("/sendUserNotification",sendUserNotification);

export default router;