import { getIo } from "../../socket.js";
import { ChatHistory } from "../../model/chatsModel.js";
import { Message } from "../../model/messagesModel.js";
import mongoose from "mongoose";
import { Patient } from "../../model/patientModel.js";
import { Therapist } from "../../model/therapistModel.js";

let io; // Store io instance

export const setIo = (socketIo) => {
  io = socketIo; // Set io from index.js
};

const getSecondUser = async (userId) => {
 const  secondUser =  await Patient.findOne({ _id: userId
  }) || await Therapist.findOne
  ({ _id: userId });
  if (!secondUser) {
      return res.status(404).json({
          success: false,
          message: "User not found"
      });
  }

  return secondUser;
}

export const getAllChatsHistoryByUserId = async (req, res) => {
    const query  = req.query;

    const userId = query.userId;

    if(userId){
       try {

        const chatsHistory = await ChatHistory.find({ $or: [{ senderId: userId }, { receiverId: userId }] }); 
        // Map chats and await secondUser details
        const chatData = await Promise.all(
          chatsHistory.map(async (chat) => {
              const secondUserId = chat.senderId == userId ? chat.receiverId : chat.senderId;
              console.log(chat.senderId, chat.receiverId == userId, chat.senderId == userId, secondUserId)
              const secondUser = await getSecondUser(secondUserId);
              
              return {
                  chatId: chat.chatId,
                  senderId: chat.senderId,
                  receiverId: chat.receiverId,
                  lastMessage: chat.lastMessage,
                  lastMessageTime: chat.lastMessageTime,
                  countOfUnreadMessages: chat.countOfUnreadMessages,
                  isRead: chat.isRead,
                  secondUser
              };
          })
      );

        res.status(200).json(
          {
            success: true,
            data: chatData
            
          }
        );
       } catch (err) {
        res.status(500).json({ message: err.message });
      }
    } else{
        res.status(400).json({ message: "User ID is required" });
    }
};

export const getAllMessagesByChatId = async (req, res) => {
    const { userId } = req.params;
    const { chatId } = req.query;

    try {
        // Use findOne instead of find for a single document
        const conversation = await ChatHistory.findOne({ chatId });

        if (!conversation) {
            return res.status(404).json({
                success: false,
                message: "Conversation not found"
            });
        }

        // Identify the other participant
        const secondUserId = conversation.senderId === userId ? conversation.receiverId : conversation.senderId;

        // Fetch second user details (combine Patient/Therapist query with $or if possible)
        const secondUser = await Patient.findOne({ _id: secondUserId }) || await Therapist.findOne({ _id: secondUserId });

        if (!secondUser) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        // Fetch messages with an index hint if needed
        const messages = await Message.find({ conversationId: chatId }) // Match your schema field name
            .sort({ createdAt: 1 }) // Use camelCase to match typical Mongoose schema
            .lean(); // Faster by returning plain JS objects

        // Send response
        res.status(200).json({
            success: true,
            data: {
                secondUser: {
                    id: secondUser._id,
                    username: secondUser.FullName,
                    profilePicture: secondUser.profilePicture,
                    role: secondUser.role,
                },
                messages: messages.map(msg => ({
                    chatId: chatId,
                    senderId: msg.senderId,
                    receiverId: msg.receiverId,
                    message: msg.content,
                    isRead: msg.isRead,
                    timestamp: msg.createdAt 
                }))
            }
        });
    } catch (error) {
        console.error("Error fetching chat details:", error);
        res.status(500).json({
            success: false,
            message: "Failed to fetch chat details",
            error: error.message
        });
    }
};

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
  
      if (!chatId) {
        const newChat = new ChatHistory({
          chatId: new mongoose.Types.ObjectId(),
          senderId,
          receiverId,
          lastMessage: message,
          lastMessageTime: Date.now(),
          countOfUnreadMessages: 1,
          isRead: false,
        });
        await newChat.save();
        finalChatId = newChat.chatId;
  
        const newMessage = new Message({
          conversationId: finalChatId,
          senderId,
          receiverId,
          content: message,
          isRead: false,
        });
        await newMessage.save();
      } else {
        // ... (rest of saveMessage logic)
      }
  
      const socketIo = getIo(); // Use shared io instance
      socketIo.to(finalChatId).emit("message", {
        senderId,
        message,
        receiverId,
        timestamp: new Date(),
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