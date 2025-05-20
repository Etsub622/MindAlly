// const express = require('express');
import axios from "axios";
import crypto from "crypto";
import { v4 as uuidv4 } from 'uuid';
import dotenv from 'dotenv';
dotenv.config();


const chapa_webhook_secret = process.env.CHAPA_WEBHOOK_SECRET;
const chapa_key = process.env.CHAPA_API_KEY


// const app = express()


const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${chapa_key}`
};


// app.use(express.json())

const acceptPayment = async (req, res) => {
    try {
        const { amount, phone_number } = req.body;
        const tx_ref = uuidv4();

        const data = {
            amount,
            phone_number,
            tx_ref,
        };

        const url = 'https://api.chapa.co/v1/transaction/initialize';
        console.log(data.tx_ref)

        const headers = {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${chapa_key}`,
        };

        const response = await axios.post(url,  data , { headers });

        console.log('Chapa API Response:', response.data);
        res.json(response.data);
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
        res.status(500).json({ error: 'Payment request failed' });
    }
};

const verifyPayment = async (req, res) => {
  try {
    const hash = crypto
      .createHmac("sha256", chapa_webhook_secret)
      .update(JSON.stringify(req.body))
      .digest("hex");

    console.log('Received x-chapa-signature:', hash);

    if (hash !== req.headers["x-chapa-signature"]) {
      return res.status(400).json({ message: "Invalid signature" });
    }

    const { tx_ref, status } = req.body;

    if (status === "success" && tx_ref) {
      // Call Chapa API to verify payment
      const response = await axios.get(
        `https://api.chapa.co/v1/transaction/verify/${tx_ref}`,
        {
          headers: {
            Authorization: `Bearer ${chapa_key}`,
          },
        }
      );

      console.log("Chapa Verification Response:", response.data);

      if (response.status === 200 && response.data.status === "success") {
        return res.status(200).json({ message: "Payment verified successfully" });
      } else {
        return res.status(400).json({ message: "Payment verification failed" });
      }
    } else {
      return res.status(400).json({ message: "Invalid payment status or missing transaction reference" });
    }
  } catch (err) {
    console.error('Error verifying payment:', err);
    return res.status(500).json({ msg: err.message });
  }
};



export { acceptPayment ,verifyPayment}

