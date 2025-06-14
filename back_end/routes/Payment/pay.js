import express from 'express';
import { acceptPayment, verifyPayment, getChapaBanks, refundToPatient ,withdrawFromWallet,getPaymentStatus} from '../../controller/Payment/acceptPayment.js';
import { authenticate } from '../../utils/authenticate.js';

const router = express.Router();
const app=express()

router.post('/pay', acceptPayment)
router.post("/webhook", express.raw({ type: "*/*" }), verifyPayment);
router.post('/withdraw', withdrawFromWallet)
router.get('/getbankCode', getChapaBanks)
router.post('/refund', refundToPatient)
router.get('/status', getPaymentStatus);

// app.use(express.json());

export default router;





 