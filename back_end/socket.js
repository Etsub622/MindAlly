import { Server } from "socket.io";
import { ChatHistory } from "./model/chatsModel.js";
import { Message } from "./model/messagesModel.js";
import { Session } from "./model/sessionModel.js";
import mongoose from "mongoose";

let io;

export const initializeSocket = (httpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: "*",
      methods: ["GET", "POST"],
    },
  });

  io.on("connection", (socket) => {
    console.log("a user connected", socket.id);

    socket.on("joinChat", (chatId) => {
      socket.join(chatId);
      console.log(`User ${socket.id} joined chat ${chatId}`);
    });

    socket.on("sendMessage", async ({ chatId, senderId, message, receiverId, timestamp }) => {
      console.log(`Message received: ${message}`);

      if (!senderId || !message || !receiverId) {
        console.error("Missing required fields:", { senderId, message, receiverId });
        socket.emit("messageError", { error: "Missing required fields" });
        return;
      }

      try {
        let finalChatId = chatId;

        let existingChat = await ChatHistory.findOne({
          $or: [
            { senderId, receiverId },
            { senderId: receiverId, receiverId: senderId },
          ],
        });

        if (existingChat) {
          finalChatId = existingChat.chatId;
          await ChatHistory.updateOne(
            { chatId: finalChatId },
            {
              $set: {
                lastMessage: message,
                lastMessageTime: new Date(timestamp),
              },
              $inc: { countOfUnreadMessages: 1 },
            }
          );
        } else if (!finalChatId) {
          const newChat = new ChatHistory({
            senderId,
            receiverId,
            lastMessage: message,
            lastMessageTime: new Date(timestamp),
            countOfUnreadMessages: 1,
            isRead: false,
          });
          await newChat.save();
          finalChatId = newChat.chatId;
        }

        const newMessage = new Message({
          conversationId: finalChatId,
          senderId,
          receiverId,
          content: message,
          isRead: false,
          createdAt: new Date(timestamp),
        });
        await newMessage.save();

        io.to(finalChatId).emit("newMessage", {
          senderId,
          message,
          receiverId,
          chatId: finalChatId,
          timestamp: timestamp,
          isRead: false,
        });

        socket.emit("messageSent", { chatId: finalChatId });
      } catch (error) {
        console.error("Error saving Socket.IO message:", error);
        if (error.code === 11000) {
          socket.emit("messageError", { error: "Chat already exists" });
        } else {
          socket.emit("messageError", { error: error.message });
        }
      }
    });

    // Handle check-in event
    socket.on("checkIn", async ({ sessionId, userId, isTherapist }) => {
      try {
        const session = await Session.findById(sessionId);
        if (!session) {
          socket.emit("checkInError", { error: "Session not found" });
          return;
        }

        // Determine the next index (based on the last check-in index)
        const checkInArray = isTherapist ? session.therapistCheckInTimes : session.patientCheckInTimes;
        const nextIndex = checkInArray.length > 0 ? checkInArray[checkInArray.length - 1].index + 1 : 1;

        const updateField = isTherapist
          ? { $push: { therapistCheckInTimes: { index: nextIndex, time: new Date() } } }
          : { $push: { patientCheckInTimes: { index: nextIndex, time: new Date() } } };

        await Session.updateOne({ _id: sessionId }, updateField);
        console.log(`Check-in recorded for ${isTherapist ? "therapist" : "patient"} in session ${sessionId} at index ${nextIndex}`);
        socket.emit("checkInSuccess", { sessionId, userId, index: nextIndex });
      } catch (error) {
        console.error("Error recording check-in:", error);
        socket.emit("checkInError", { error: error.message });
      }
    });

    // Handle check-out event
    socket.on("checkOut", async ({ sessionId, userId, isTherapist }) => {
      try {
        const session = await Session.findById(sessionId);
        if (!session) {
          socket.emit("checkOutError", { error: "Session not found" });
          return;
        }

        // Use the latest check-in index for the check-out
        const checkInArray = isTherapist ? session.therapistCheckInTimes : session.patientCheckInTimes;
        const latestIndex = checkInArray.length > 0 ? checkInArray[checkInArray.length - 1].index : 1;

        const updateField = isTherapist
          ? { $push: { therapistCheckOutTimes: { index: latestIndex, time: new Date.now() } } }
          : { $push: { patientCheckOutTimes: { index: latestIndex, time: new Date.now() } } };

        await Session.updateOne({ _id: sessionId }, updateField);
        console.log(`Check-out recorded for ${isTherapist ? "therapist" : "patient"} in session ${sessionId} at index ${latestIndex}`);
        socket.emit("checkOutSuccess", { sessionId, userId, index: latestIndex });
      } catch (error) {
        console.error("Error recording check-out:", error);
        socket.emit("checkOutError", { error: error.message });
      }
    });

    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
    });
  });

  return io;
};

export const getIo = () => {
  if (!io) {
    throw new Error("Socket.IO not initialized");
  }
  return io;
};