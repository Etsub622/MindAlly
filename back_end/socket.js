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
      console.log(`Message received in chat ${chatId}: ${message}`);

      if (!senderId || !message || !receiverId) {
        console.error("Missing required fields:", { senderId, message, receiverId });
        socket.emit("messageError", { error: "Missing required fields" });
        return;
      }

      try {
        console.log("Saving Socket.IO message:", { senderId, message, receiverId, timestamp });
        let finalChatId = chatId;

        if (!chatId) {
          const newChat = new ChatHistory({
            chatId: new mongoose.Types.ObjectId(),
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

        if (chatId) {
          const existingChat = await ChatHistory.findOne({ chatId });
          if (existingChat) {
            await ChatHistory.updateOne(
              { chatId },
              {
                $set: {
                  lastMessage: message,
                  lastMessageTime: new Date(timestamp),
                },
                $inc: { countOfUnreadMessages: 1 },
              }
            );
          }
        }

        io.to(finalChatId).emit("newMessage", {
          senderId,
          message,
          receiverId,
          timestamp: timestamp,
        });
      } catch (error) {
        console.error("Error saving Socket.IO message:", error);
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