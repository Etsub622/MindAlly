import mongoose from "mongoose";

const conversationSchema = new mongoose.Schema({
    participant_one: {
        type: mongoose.Schema.Types.ObjectId,
        refPath: "participantOneModel",
        required: true
    },
    participant_two: {
        type: mongoose.Schema.Types.ObjectId,
        refPath: "participantTwoModel",
        required: true
    },
    lastMessage: {
        type: String,
        default: ""
    },
    lastMessageTime: {
        type: Date,
        default: Date.now
    }
}, { timestamps: true });

const Conversation = mongoose.model("Conversation", conversationSchema);

export { Conversation };
