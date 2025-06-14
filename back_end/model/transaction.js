import mongoose from "mongoose";

const transactionSchema = new mongoose.Schema({
    therapistEmail: { type: String, ref: "Therapist" },
    patientEmail: { type: String, ref: "Patient" }, // Add this for refunds and tracking
    type: { type: String }, // "credit", "debit", "refund_to_patient"
    amount: { type: Number },
    status: { type: String }, // "pending", "completed", "failed", "pending_account_details"
    reference: { type: String }, // Unique reference for this transaction (e.g., Chapa tx_ref or refund ref)
    originalTxRef: { type: String }, // For refunds: reference to the original payment
    createdAt: { type: Date, default: Date.now }
});

const Transaction = mongoose.model("Transaction", transactionSchema);
export { Transaction };