
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
      res.json(response.data);
  } catch (error) {
      console.error('Error:', error.response ? error.response.data : error.message);
      res.status(500).json({ error: 'Payment request failed' });
  }
};



 const verifyPayment = async (req, res) => {
    
        try {
            // const signature = req.headers["chapa-signature"] || req.headers["x-chapa-signature"];
            // const bodyBuffer = Buffer.isBuffer(req.body) ? req.body : Buffer.from(JSON.stringify(req.body));
            // const hash = crypto
            //     .createHmac("sha256", chapa_webhook_secret)
            //     .update(bodyBuffer)
            //     .digest("hex");
            // console.log('Received x-chapa-signature:', signature);
            // console.log('Calculated hash:', hash);
    
            // if (hash !== signature) {
            //     return res.status(400).json({ message: "Invalid signature" });
            // }
        
            const body = Buffer.isBuffer(req.body) ? JSON.parse(req.body) : req.body;
            const { tx_ref, status, metadata, amount } = body;

        if (status === "success" && tx_ref) {
          
            const response = await axios.get(`https://api.chapa.co/v1/transaction/verify/${tx_ref}`, { headers: { Authorization: `Bearer ${chapa_key}` } });

            
          
          const therapistEmail = metadata?.therapistEmail;
          const patientEmail = metadata?.patientEmail;
              if (therapistEmail) {
                  const therapist = await Therapist.findOne({ Email: therapistEmail });
                  if (therapist) {
                      therapist.wallet += Number(amount);
                      await therapist.save();

                    await Transaction.create({
                      therapistEmail,
                       patientEmail,
                        type: "credit",
                        amount,
                      status: "completed",
                      reference: tx_ref 
                    });
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





const withdrawFromWallet = async (req, res) => {
  try {
    const { therapistEmail, amount } = req.body;
    const amountNumber = Number(amount);

    if (isNaN(amountNumber) || amountNumber <= 0) {
      return res.status(400).json({ error: "Invalid withdrawal amount" });
    }

    const therapist = await Therapist.findOne({ Email: therapistEmail });
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

      const therapist = await Therapist.findOne({ Email: therapistEmail });
      if (!therapist) {
          return res.status(404).json({ error: "Therapist not found" });
      }

      const patient = await Patient.findOne({ Email: patientEmail });
      if (!patient) {
          return res.status(404).json({ error: "Patient not found" });
      }

      // Find the last completed payment transaction from this patient to this therapist
      // Crucially, it must have a 'reference' (tx_ref from Chapa) to be refundable
      const lastPaymentTransaction = await Transaction.findOne({
          patientEmail: patientEmail,
          therapistEmail: therapistEmail,
          type: "credit",
          status: "completed",
          reference: { $exists: true, $ne: null } // Ensure 'reference' field exists and is not null
      }).sort({ createdAt: -1 });

      if (!lastPaymentTransaction) {
          return res.status(404).json({ error: "No completed payment with a valid reference found from this patient to this therapist to refund." });
      }

      // --- THE CRITICAL CHECK FOR DUPLICATE REFUNDS FOR *THIS SPECIFIC PAYMENT* ---
      // We now check if there's already a refund transaction explicitly linked
      // to the 'reference' of the 'lastPaymentTransaction'.
      const existingRefundForThisPayment = await Transaction.findOne({
          originalTxRef: lastPaymentTransaction.reference, // This links to the *specific* payment's tx_ref
          type: "refund_to_patient",
          status: { $in: ["completed", "pending_account_details"] } // Check for completed or pending refunds
      });

      if (existingRefundForThisPayment) {
          return res.status(400).json({ error: "A refund for this specific payment has already been initiated or completed." });
      }
      // --- END CRITICAL CHECK ---

      const refundAmount = lastPaymentTransaction.amount;
      const originalTxRef = lastPaymentTransaction.reference; // This is the tx_ref of the payment being refunded

      // Calculate therapist's current wallet balance from transactions
      const transactions = await Transaction.find({ therapistEmail });
      const totalCredit = transactions
          .filter(t => t.type === "credit")
          .reduce((sum, t) => sum + t.amount, 0);

      const totalDebit = transactions
          .filter(t => t.type === "debit" || t.type === "refund_to_patient")
          .reduce((sum, t) => sum + t.amount, 0);

      const currentTherapistBalance = totalCredit - totalDebit;

      if (currentTherapistBalance < refundAmount) {
          return res.status(400).json({ error: "Therapist has insufficient wallet balance for this refund." });
      }

      // If patient account details are missing, email the patient and log as pending
      if (!patientAccountNumber || !patientBankCode || !patientAccountName) {
          await transporter.sendMail({
              from: process.env.EMAIL_USER,
              to: patientEmail,
              subject: "Refund Request - Action Required",
              html: `
                  <p>Dear ${patient.FullName || 'Patient'},</p>
                  <p>A refund of ${refundAmount} ETB for your last session payment has been requested. To process this refund, please provide your bank account details by replying to this email or updating your profile in the app.</p>
                  <p>Once we receive your details, we will initiate the transfer.</p>
                  <p>Thank you.</p>
              `,
          });

          await Transaction.create({
              therapistEmail,
              patientEmail,
              type: "refund_to_patient",
              amount: refundAmount,
              status: "pending_account_details",
              originalTxRef: originalTxRef,
              reference: `REF-${uuidv4()}` // Unique reference for this refund request
          });

          return res.status(202).json({
              message: "Patient account details not provided. Email sent to patient to request details. Refund pending.",
              refundStatus: "pending_account_details",
              amountRequested: refundAmount
          });
      }

      // Proceed with direct payout if account details are provided
      const refundReference = `REF-${uuidv4()}`; // This is the reference for the Chapa transfer

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
              reference: refundReference, // Store the reference of the Chapa transfer here
              originalTxRef: originalTxRef // Store the original payment's tx_ref here
          });

          return res.status(200).json({
              success: true,
              message: "Refund successful and transferred to patient's account.",
              refundReference: refundReference,
              newTherapistBalance: currentTherapistBalance - refundAmount
          });
      } else {
          await Transaction.create({
              therapistEmail,
              patientEmail,
              type: "refund_to_patient",
              amount: refundAmount,
              status: "failed",
              reference: refundReference,
              originalTxRef: originalTxRef
          });
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


export { acceptPayment, verifyPayment, withdrawFromWallet, getChapaBanks ,refundToPatient};
