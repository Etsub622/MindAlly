import express from 'express';
import { acceptPayment, verifyPayment ,withdrawFromWallet} from '../../controller/Payment/acceptPayment.js';
import { authenticate } from '../../utils/authenticate.js';

const router = express.Router();
const app=express()

router.post('/pay', acceptPayment)
router.post('/webhook', verifyPayment)
router.post('/withdraw', withdrawFromWallet);

// app.use(express.json());

export default router;





