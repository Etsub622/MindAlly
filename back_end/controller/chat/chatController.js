import { getIo } from "../../socket.js";
import { ChatHistory } from "../../model/chatsModel.js";
import { Message } from "../../model/messagesModel.js";
import mongoose from "mongoose";
import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";

let io;

export const setIo = (socketIo) => {
  io = socketIo;
};

const getSecondUser = async (userId) => {
  const secondUser = await Patient.findOne({ _id: userId }) || await Therapist.findOne({ _id: userId });
  if (!secondUser) {
    throw new Error("User not found");
  }
  return secondUser;
};

export const getAllChatsHistoryByUserId = async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ message: "User ID is required" });
  }

  try {
    const chatsHistory = await ChatHistory.find({
      $or: [{ senderId: userId }, { receiverId: userId }],
    });
    const chatData = await Promise.all(
      chatsHistory.map(async (chat) => {
        const secondUserId = chat.senderId.toString() === userId ? chat.receiverId : chat.senderId;
        const secondUser = await getSecondUser(secondUserId);
        return {
          chatId: chat.chatId,
          senderId: chat.senderId,
          receiverId: chat.receiverId,
          lastMessage: chat.lastMessage,
          lastMessageTime: chat.lastMessageTime,
          countOfUnreadMessages: chat.countOfUnreadMessages,
          isRead: chat.isRead,
          secondUser,
        };
      })
    );

    res.status(200).json({
      success: true,
      data: chatData,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export const getAllMessagesByChatId = async (req, res) => {
  const { userId } = req.params;
  const { chatId } = req.query;

  try {
    const conversation = await ChatHistory.findOne({ chatId });
    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: "Conversation not found",
      });
    }

    const secondUserId = conversation.senderId.toString() === userId ? conversation.receiverId : conversation.senderId;
    const secondUser = await Patient.findOne({ _id: secondUserId }) || await Therapist.findOne({ _id: secondUserId });

    if (!secondUser) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    const messages = await Message.find({ conversationId: chatId })
      .sort({ createdAt: 1 })
      .lean();

    res.status(200).json({
      success: true,
      data: {
        secondUser: {
          id: secondUser._id,
          username: secondUser.FullName,
          profilePicture: secondUser.profilePicture,
          role: secondUser.role,
        },
        messages: messages.map((msg) => ({
          chatId: chatId,
          senderId: msg.senderId,
          receiverId: msg.receiverId,
          message: msg.content,
          isRead: msg.isRead,
          timestamp: msg.createdAt,
        })),
      },
    });
  } catch (error) {
    console.error("Error fetching chat details:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch chat details",
      error: error.message,
    });
  }
};

// Consolidated saveMessage to use Socket.IO logic
export const saveMessage = async (req, res) => {
  const { chatId, senderId, message, receiverId } = req.body;
  console.log("INCOMING MESSAGE", req.body);

  if (!senderId || !message || !receiverId) {
    return res.status(400).json({
      success: false,
      message: "senderId, message, and receiverId are required",
    });
  }

  try {
    let finalChatId = chatId;

    // Check for an existing chat
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
            lastMessageTime: new Date(),
          },
          $inc: { countOfUnreadMessages: 1 },
        }
      );
    } else if (!finalChatId) {
      const newChat = new ChatHistory({
        senderId,
        receiverId,
        lastMessage: message,
        lastMessageTime: new Date(),
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
    });
    await newMessage.save();

    const socketIo = getIo();
    socketIo.to(finalChatId).emit("newMessage", {
      senderId,
      message,
      receiverId,
      chatId: finalChatId,
      timestamp: new Date(),
      isRead: false,
    });

    res.status(201).json({
      success: true,
      message: "Message saved successfully",
      chatId: finalChatId,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to save message",
      error: error.message,
    });
  }
};