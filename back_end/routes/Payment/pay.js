import express from 'express';
import { acceptPayment, getChapaBanks, refundToPatient, verifyPayment ,withdrawFromWallet} from '../../controller/Payment/acceptPayment.js';
import { authenticate } from '../../utils/authenticate.js';

const router = express.Router();
const app=express()

router.post('/pay', acceptPayment)
router.post('/webhook', verifyPayment)
router.post('/withdraw', withdrawFromWallet)
router.get('/getbankCode', getChapaBanks)
router.post('/refund', refundToPatient)

// app.use(express.json());

export default router;





