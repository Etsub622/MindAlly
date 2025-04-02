import express from 'express';
import { acceptPayment, verifyPayment } from '../../controller/Payment/acceptPayment.js';

const router = express.Router();

router.post('/pay', acceptPayment)
router.post('/webhook',verifyPayment)

export default router;





