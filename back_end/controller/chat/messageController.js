import { ChatHistory } from "../../model/chatsModel";
import { Message } from "../../model/messagesModel";


export const getAllMessagesByChatId = async (req, res) => {
    const { userId } = req.params;
    const { chatId } = req.query;

    console.log(chatId, "chatId");    
    try {
        const conversation = await ChatHistory.findOne({ chatId: chatId }).toArray();

        if (!conversation) {
            throw new Error("Conversation not found");
        }

        // Identify the other participant
        const secondUserId = conversation[0].senderId === userId ? conversation[0].receiverId : conversation[0].senderId;

        // Fetch second user details
        const secondUser = await Patient.findOne( { _id: secondUserId }) || Therapist.findOne( { _id: secondUserId });

        if (!secondUser) {
            throw new Error("User not found");
        }

        // Fetch messages for the chat
        const messages = await Message.find(
            { conversation_id: chatId },
        ).sort({ created_at: 1 }).toArray();

        // Format response
        return {
            chatId,
            secondUser: {
                id: secondUser._id,
                username: secondUser.FullName,
                profilePicture: secondUser.profilePicture,
                role: secondUser.role,
            },
            messages: messages.map(msg => ({
                senderId: msg.senderId,
                receiverId: msg.receiverId,
                message: msg.content,
                isRead: msg.isRead,
                timestamp: msg.created_at
            }))
        };
    } catch (error) {
        console.error("Error fetching chat details:", error);
        throw new Error("Failed to fetch chat details");
    }
};