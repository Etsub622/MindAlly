import express from 'express';
import { acceptPayment, verifyPayment } from '../../controller/Payment/acceptPayment.js';
import { authenticate } from '../../utils/authenticate.js';

const router = express.Router();

router.post('/pay', authenticate, acceptPayment)
router.post('/webhook',verifyPayment)

export default router;





