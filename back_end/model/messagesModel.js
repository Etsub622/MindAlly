import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
    conversationId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "ChatHistory",
        required: true
    },
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Patient" || "Therapist",
        required: true
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Patient" || "Therapist",
        required: true
    },
    content: {
        type: String,
        required: true
    },
    isRead: {
        type: Boolean,
        default: false
    }
}, { timestamps: true });

const Message = mongoose.model("Message", messageSchema);

export { Message };
