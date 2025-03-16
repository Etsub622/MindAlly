import mongoose from "mongoose";

const chatschema = new mongoose.Schema({
    chatId: {
        type: String,
        unique:true
    },
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Patient" || "Therapist",
        required: true, 
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Patient" || "Therapist",
        required: true,
    },
    lastMessage: {
        type: String,
        required:true
    },
    lastMessageTime: {
        type: Date,
        required:true
    },
    countOfUnreadMessages: {
        type: Number,
        required:true
    },
    isRead : {
        type: Boolean,
        required:true
    },
})


const ChatHistory = mongoose.model("ChatHistory", chatschema)

export { ChatHistory }

chatschema.pre('save', function(next) {
    if (!this.chatId) {
        this.chatId = new mongoose.Types.ObjectId().toString();
    } 
    next();
});