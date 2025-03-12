import express from "express";
import {
    getAllChatsHistoryByUserId,
    getAllMessagesByChatId,
    saveMessage,
} from "../../controller/chat/chatController.js";
import { verifyToken } from "../../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/message/send", verifyToken, saveMessage);
router.get("/", verifyToken, getAllChatsHistoryByUserId);
router.get("/:userId", verifyToken, getAllMessagesByChatId);

export default router;
