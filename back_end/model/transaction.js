import mongoose from "mongoose";

const transactionSchema = new mongoose.Schema({
    therapistEmail: { type: String, ref: "Therapist" },
    type: { type: String }, // "credit" or "debit"
    amount: { type: Number },
    status: { type: String }, // "pending", "completed", "failed"
    createdAt: { type: Date, default: Date.now }
});

const Transaction = mongoose.model("Transaction", transactionSchema);
export { Transaction };