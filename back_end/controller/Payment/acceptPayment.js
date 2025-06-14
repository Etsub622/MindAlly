
import { Therapist } from "../../model/therapistModel.js";
import crypto from "crypto";
import { Transaction } from "../../model/transaction.js";
import { Patient } from "../../model/patientModel.js";
import nodemailer from "nodemailer";
import { v4 as uuidv4 } from "uuid";
import axios from "axios";
import dotenv from "dotenv";
dotenv.config();
const chapa_webhook_secret = process.env.CHAPA_WEBHOOK_SECRET;
const chapa_key = process.env.CHAPA_API_KEY;

const headers = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${chapa_key}`
};



// ...existing code...

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});


const getChapaBanks = async (req, res) => {
  try {
    const response = await axios.get("https://api.chapa.co/v1/banks", {
      headers: { Authorization: `Bearer ${chapa_key}` }
    });
    // Always check if data exists and return it
    if (response.data.data) {
      res.status(200).json(response.data.data); // Returns an array of bank objects
    } else {
      res.status(500).json({ error: "Failed to fetch banks from Chapa", detail: response.data });
    }
  } catch (err) {
    console.error("Error fetching Chapa banks:", err.response?.data || err.message);
    res.status(500).json({ error: "Server error fetching bank list" });
  }
};



const acceptPayment = async (req, res) => {

  try {
      const { therapistEmail, patientEmail, sessionDuration, pricePerHr} = req.body;


      const therapist = await Therapist.findOne({ Email: therapistEmail });
      if (!therapist) return res.status(404).json({ error: "Therapist not found" });


      const amount = pricePerHr * sessionDuration;
      // const amount = Fee * sessionDuration;

      const tx_ref = uuidv4();

      const data = {
          amount,
          currency: "ETB",
          tx_ref,
          // Add therapist and patient info to metadata
          metadata: {
              therapistEmail,
              patientEmail,
              sessionDuration
          }
      };

    const url = 'https://api.chapa.co/v1/transaction/initialize';
    console.log(data.tx_ref)
      const headers = {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${chapa_key}`,
      };

    const response = await axios.post(url, data, { headers });
    
    await Transaction.create({
      therapistEmail,
      patientEmail,
      type: "credit",
      amount,
      status: "pending",
      reference: tx_ref // This must match the webhook tx_ref!
    });

    // res.json(response.data);
    res.json({
      message: "Payment initialized. Redirect user to Chapa.",
      tx_ref,
      checkout_url: response.data.data.checkout_url
    });
  } catch (error) {
      console.error('Error:', error.response ? error.response.data : error.message);
      res.status(500).json({ error: 'Payment request failed' });
  }
};




// This function is meant to be used as a webhook handler with express.raw() middleware
const verifyPayment = async (req, res) => {
  try {
    // 1. Signature verification (security)
    const signature = req.headers["x-chapa-signature"] || req.headers["chapa-signature"];
    const bodyBuffer = req.body; // req.body is a Buffer because of express.raw()
    console.log('Is Buffer:', Buffer.isBuffer(bodyBuffer));
    const hash = crypto
      .createHmac("sha256", chapa_webhook_secret)
      .update(bodyBuffer)
      .digest("hex");
      console.log('Is Buffer:', Buffer.isBuffer(bodyBuffer));
      console.log('Raw body:', bodyBuffer.toString());
      console.log('Computed hash:', hash);
      console.log('Received signature:', signature);
      

    if (hash !== signature) {
      return res.status(400).json({ message: "Invalid signature" });
    }

    // 2. Parse the body after signature verification
    const body = JSON.parse(bodyBuffer.toString());
    const { tx_ref, status, metadata, amount } = body;

    // 3. Only process successful payments
    console.log('Webhook tx_ref:', tx_ref);
    if (status === "success" && tx_ref) {
      // Find and update the transaction
      const tx = await Transaction.findOne({ reference: tx_ref });
      console.log('Found transaction:', tx);
      if (tx && tx.status !== "completed") {
        tx.status = "completed";
        await tx.save();
        console.log(req.headers);
        // Optionally update therapist wallet
        if (tx.therapistEmail) {
          const therapist = await Therapist.findOne({ Email: tx.therapistEmail });
          if (therapist) {
            therapist.wallet += Number(amount);
            await therapist.save();
          }
        }
      }
      return res.status(200).json({ message: "Payment verified and wallet credited" });
    } else {
      return res.status(400).json({ message: "Invalid payment status or missing transaction reference" });
    }
  } catch (err) {
    console.error('Error verifying payment:', err);
    return res.status(500).json({ msg: err.message });
  }
};

const getPaymentStatus = async (req, res) => {
  const { tx_ref } = req.query;
  const tx = await Transaction.findOne({ reference: tx_ref });
  if (!tx) return res.status(404).json({ status: "not_found" });
  res.json({ status: tx.status });
};




const withdrawFromWallet = async (req, res) => {
  try {
    const { therapistEmail, amount } = req.body;
    const amountNumber = Number(amount);

    if (isNaN(amountNumber) || amountNumber <= 0) {
      return res.status(400).json({ error: "Invalid withdrawal amount" });
    }

    const therapist = await Therapist.findOne({ Email: therapistEmail });
    console.log("Therapist found:", therapistEmail);
    if (!therapist) return res.status(404).json({ error: "Therapist not found" });

    // Calculate wallet balance from transaction history
    const transactions = await Transaction.find({ therapistEmail });

    const totalCredit = transactions
      .filter(t => t.type === "credit")
      .reduce((sum, t) => sum + t.amount, 0);

    const totalDebit = transactions
      .filter(t => t.type === "debit")
      .reduce((sum, t) => sum + t.amount, 0);

    const currentBalance = totalCredit - totalDebit;

    if (currentBalance < amountNumber) {
      return res.status(400).json({ error: "Insufficient wallet balance" });
    }

    const { account_name, account_number, bank_code } = therapist.payout || {};
    
    if (!account_name || !account_number || !bank_code) {
      console.log("Therapist payout information is incomplete:", therapist.payout);
      return res.status(400).json({ error: "Therapist payout information is incomplete" });
    }

    const transferData = {
      account_name,
      account_number,
      amount: String(amountNumber),
      currency: "ETB",
      bank_code,
      reference: uuidv4()
    };

    // const response = await axios.post(
    //   "https://api.chapa.co/v1/transfers",
    //   transferData,
    //   { headers: { Authorization: `Bearer ${chapa_key}` } }
    // );
    let response;
    if (process.env.NODE_ENV === "test") {
      // MOCKED SUCCESS RESPONSE FOR TESTING
      response = { data: { status: "success" } };
    } else {
      // REAL CHAPA CALL
      response = await axios.post(
        "https://api.chapa.co/v1/transfers",
        transferData,
        { headers: { Authorization: `Bearer ${chapa_key}` } }
      );
    }


    if (response.data.status === "success") {
      // Log debit transaction (don’t update therapist.wallet)
      await Transaction.create({
        therapistEmail,
        type: "debit",
        amount: amountNumber,
        status: "completed",
        reference: transferData.reference
      });

      return res.status(200).json({
        success: true,
        newBalance: currentBalance - amountNumber,
        message: "Withdrawal successful",
        transferReference: transferData.reference
      });
    } else {
      return res.status(500).json({
        error: "Transfer failed",
        detail: response.data
      });
    }
  } catch (err) {
    console.error("Error during withdrawal:", err.response?.data || err.message);
    res.status(500).json({ error: err.message });
  }
};


// ... (imports and existing code) ...

const refundToPatient = async (req, res) => {
  try {
    const { patientEmail, therapistEmail, patientAccountNumber, patientBankCode, patientAccountName } = req.body;

    // 1. Check for all required fields first
    if (!patientEmail || !therapistEmail || !patientAccountNumber || !patientBankCode || !patientAccountName) {
      return res.status(400).json({
        error: "All patient and therapist details are required for a refund."
      });
    }

    // 2. Find therapist and patient
    const therapist = await Therapist.findOne({ Email: therapistEmail });
    if (!therapist) return res.status(404).json({ error: "Therapist not found" });

    const patient = await Patient.findOne({ Email: patientEmail });
    if (!patient) return res.status(404).json({ error: "Patient not found" });

    // 3. Find the last completed payment transaction
    const lastPaymentTransaction = await Transaction.findOne({
      patientEmail,
      therapistEmail,
      type: "credit",
      status: "completed",
      reference: { $exists: true, $ne: null }
    }).sort({ createdAt: -1 });

    if (!lastPaymentTransaction) {
      return res.status(404).json({ error: "No completed payment with a valid reference found from this patient to this therapist to refund." });
    }

    // 4. Check for existing refund
    const existingRefund = await Transaction.findOne({
      originalTxRef: lastPaymentTransaction.reference,
      type: "refund_to_patient",
      status: { $in: ["completed", "pending_account_details"] }
    });

    if (existingRefund) {
      return res.status(400).json({ error: "A refund for this specific payment has already been initiated or completed." });
    }

    // 5. Check therapist balance
    const transactions = await Transaction.find({ therapistEmail });
    const totalCredit = transactions.filter(t => t.type === "credit").reduce((sum, t) => sum + t.amount, 0);
    const totalDebit = transactions.filter(t => t.type === "debit" || t.type === "refund_to_patient").reduce((sum, t) => sum + t.amount, 0);
    const currentTherapistBalance = totalCredit - totalDebit;
    const refundAmount = lastPaymentTransaction.amount;
    const originalTxRef = lastPaymentTransaction.reference;

    if (currentTherapistBalance < refundAmount) {
      return res.status(400).json({ error: "Therapist has insufficient wallet balance for this refund." });
    }

    // 6. Proceed with direct payout if all details are present
    const refundReference = `REF-${uuidv4()}`;
    const transferData = {
      account_name: patientAccountName,
      account_number: patientAccountNumber,
      amount: String(refundAmount),
      currency: "ETB",
      bank_code: patientBankCode,
      reference: refundReference
    };

    let response;
    if (process.env.NODE_ENV === "test") {
      response = { data: { status: "success" } };
    } else {
      response = await axios.post(
        "https://api.chapa.co/v1/transfers",
        transferData,
        { headers: { Authorization: `Bearer ${chapa_key}` } }
      );
    }

    if (response.data.status === "success") {
      await Transaction.create({
        therapistEmail,
        patientEmail,
        type: "refund_to_patient",
        amount: refundAmount,
        status: "completed",
        reference: refundReference,
        originalTxRef: originalTxRef
      });

      return res.status(200).json({
        success: true,
        message: "Refund successful and transferred to patient's account.",
        refundReference: refundReference,
        newTherapistBalance: currentTherapistBalance - refundAmount
      });
    } else {
      return res.status(500).json({
        error: "Refund transfer failed via Chapa.",
        detail: response.data
      });
    }

  } catch (err) {
    console.error("Error initiating refund:", err.response?.data || err.message);
    res.status(500).json({ error: "Server error during refund initiation." });
  }
};

// ... (export statement) ...


export { acceptPayment, verifyPayment, withdrawFromWallet, getChapaBanks ,refundToPatient,getPaymentStatus};
