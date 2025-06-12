import express from "express";
import { verifyToken } from "../../middlewares/authMiddleware.js";
import { saveToken, sendNotification } from "../../utils/notificationUtils.js";
import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";

const router = express.Router();

export const saveFCMToken = async (req) => {
    const { userId, token } = req.body;

    if (!userId || !token) {
        throw new Error("userId and token are required");
    }

    try {
        const message = await saveToken(userId, token);
        return {
            success: true,
            message
        };
    } catch (error) {
        console.error("Error saving FCM token:", error.message);
        throw new Error(error.message.includes("not defined") 
            ? "User not found" 
            : "Failed to save FCM token");
    }
};

export const sendUserNotification = async (req, res) => {
    const { receiverId, senderId, message } = req.body; // senderId now required from frontend

    if (!receiverId || !senderId || !message) {
        return res.status(400).json({ success: false, message: "receiverId, senderId, and message are required" });
    }

    try {
        let receiver = await Patient.findById(receiverId);
        if (!receiver) {
            receiver = await Therapist.findById(receiverId);
        }

        if (!receiver) {
            return res.status(404).json({ success: false, message: "Receiver not found" });
        }

        const fcmToken = receiver.fcmToken;
        if (!fcmToken) {
            return res.status(400).json({ success: false, message: "No FCM token found for receiver" });
        }

        const title = "New Message";
        const body = message;
        const data = { 
            notificationType: "new_message",
            senderId: senderId, // Rely solely on the provided senderId
            receiverId: receiverId.toString(),
        };

        await sendNotification(fcmToken, title, body, data);

        return res.status(200).json({
            success: true,
            notification: {
                receiverId: receiver._id,
                senderId: senderId,
                title,
                body,
                timestamp: new Date(),
            },
            message: "Notification sent successfully"
        });
    } catch (error) {
        console.error("Error sending notification:", error.message);
        return res.status(500).json({ success: false, message: "Failed to send notification" });
    }
};
