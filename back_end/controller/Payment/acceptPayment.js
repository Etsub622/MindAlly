// // const express = require('express');
// import axios from "axios";
// import crypto from "crypto";
// import { v4 as uuidv4 } from 'uuid';
// import dotenv from 'dotenv';
// dotenv.config();


// const chapa_webhook_secret = process.env.CHAPA_WEBHOOK_SECRET;
// const chapa_key = process.env.CHAPA_API_KEY


// // const app = express()


// const headers = {
//     'Content-Type': 'application/json',
//     'Authorization': `Bearer ${chapa_key}`
// };


// // app.use(express.json())

// const acceptPayment = async (req, res) => {
//     try {
//         const { amount, phone_number } = req.body;
//         const tx_ref = uuidv4();

//         const data = {
//             amount,
//             phone_number,
//             tx_ref,
//         };

//         const url = 'https://api.chapa.co/v1/transaction/initialize';
//         console.log(data.tx_ref)

//         const headers = {
//             'Content-Type': 'application/json',
//             'Authorization': `Bearer ${chapa_key}`,
//         };

//         const response = await axios.post(url,  data , { headers });

//         console.log('Chapa API Response:', response.data);
//         res.json(response.data);
//     } catch (error) {
//         console.error('Error:', error.response ? error.response.data : error.message);
//         res.status(500).json({ error: 'Payment request failed' });
//     }
// };

// const verifyPayment = async (req, res) => {
//   try {
//     const hash = crypto
//       .createHmac("sha256", chapa_webhook_secret)
//       .update(JSON.stringify(req.body))
//       .digest("hex");

//     console.log('Received x-chapa-signature:', hash);

//     if (hash !== req.headers["x-chapa-signature"]) {
//       return res.status(400).json({ message: "Invalid signature" });
//     }

//     const { tx_ref, status } = req.body;

//     if (status === "success" && tx_ref) {
//       // Call Chapa API to verify payment
//       const response = await axios.get(
//         `https://api.chapa.co/v1/transaction/verify/${tx_ref}`,
//         {
//           headers: {
//             Authorization: `Bearer ${chapa_key}`,
//           },
//         }
//       );

//       console.log("Chapa Verification Response:", response.data);

//       if (response.status === 200 && response.data.status === "success") {
//         return res.status(200).json({ message: "Payment verified successfully" });
//       } else {
//         return res.status(400).json({ message: "Payment verification failed" });
//       }
//     } else {
//       return res.status(400).json({ message: "Invalid payment status or missing transaction reference" });
//     }
//   } catch (err) {
//     console.error('Error verifying payment:', err);
//     return res.status(500).json({ msg: err.message });
//   }
// };



// export { acceptPayment ,verifyPayment}

import { Therapist } from "../../model/therapistModel.js";
import crypto from "crypto";
import { Transaction } from "../../model/transaction.js";
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
              if (therapistEmail) {
                  const therapist = await Therapist.findOne({ Email: therapistEmail });
                  if (therapist) {
                      therapist.wallet += Number(amount);
                      await therapist.save();

                    await Transaction.create({
                        therapistEmail,
                        type: "credit",
                        amount,
                        status: "completed"
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


export { acceptPayment, verifyPayment, withdrawFromWallet, getChapaBanks };
