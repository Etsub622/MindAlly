import { Server } from "socket.io";
import { ChatHistory } from "./model/chatsModel.js";
import { Message } from "./model/messagesModel.js";
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

        // Check for an existing chat between senderId and receiverId
        let existingChat = await ChatHistory.findOne({
          $or: [
            { senderId, receiverId },
            { senderId: receiverId, receiverId: senderId },
          ],
        });

        if (existingChat) {
          // Reuse the existing chat
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
          // Create a new chat if none exists and no chatId is provided
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

        // Save the message
        const newMessage = new Message({
          conversationId: finalChatId,
          senderId,
          receiverId,
          content: message,
          isRead: false,
          createdAt: new Date(timestamp),
        });
        await newMessage.save();

        // Emit the new message to the chat room
        io.to(finalChatId).emit("newMessage", {
          senderId,
          message,
          receiverId,
          chatId: finalChatId,
          timestamp: timestamp,
          isRead: false,
        });

        // Notify the sender of the chatId
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