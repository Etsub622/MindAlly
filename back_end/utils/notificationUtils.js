import admin from "firebase-admin";
import serviceAccount from '../config/firebase-service-account.json' with { type: "json" };
import { Patient } from "../model/patientModel.js";
import { Therapist } from "../model/therapistModel.js"

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

export const sendNotification = async (fcmToken, title, body, data) => {
    if (!fcmToken || !title || !body) {
        throw new Error('Missing required fields: fcmToken, title, or body');
    }
    const message = {
        notification: { title, body },
        data,
        token: fcmToken,
    };
    try {
        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);
        return response;
    } catch (error) {
        console.error('Error sending notification:', error);
        throw error;
    }
};

export const saveToken = async (userId, token) => {
    console.log("saveToken called with:", { userId, token });

    // Check both Patient and Therapist models
    const user = await Patient.findOne({ _id: userId }) || await Therapist.findOne({ _id: userId })
    
    if (!user) {
        throw new Error("User not found");
    }
    console.log("User found:", user);
    user.fcmToken = token;
    await user.save();
    console.log("FCM token saved for user:", userId);
    return "FCM token saved successfully";
};
