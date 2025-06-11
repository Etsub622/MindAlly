import express from "express";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import cors from "cors";
import cookieParser from "cookie-parser";
import { createServer } from "http";
import { initializeSocket } from "./socket.js";
import { connectDB } from "./db.js";
import userRoutes from "./routes/authenticaionRoutes/userAuth.js";
import otpRoutes from "./routes/authenticaionRoutes/otpRoutes.js";
// import googleRoutes from "./routes/authenticaionRoutes/loginwithGoogle.js";
import patientRoutes from "./routes/profile/profile.js";
import therapistRoutes from "./routes/profile/therapist.js";
import chatRoutes from "./routes/chat/chatRoutes.js";
import { resourceRoutes } from "./routes/resource/resourceRoutes.js";
import { setIo } from "./controller/chat/chatController.js";
import paymentRoutes from "./routes/Payment/pay.js";

dotenv.config();
import answerRoutes from "./routes/qanda/answerRoutes.js";
import questionRoutes from "./routes/qanda/questionRoutes.js";
// import answerRoutes from "./routes/q&a/answerRoutes.js";
import {scheduleRoutes} from "./routes/scheduler/scheduleRoutes.js";

const app = express();
const httpServer = createServer(app);

// Middleware
app.use(bodyParser.json());
app.use(cookieParser());
app.use(cors({
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type"],
  credentials: true,
}));

// Root route
app.get("/", (req, res) => {
  res.send("<a href='/api/google/authgoogle'> login with google </a>");
});

// Routes
app.use("/api/user", userRoutes);
app.use("/api/otp", otpRoutes);
// app.use("/api/google", googleRoutes);

app.use("/api/patients", patientRoutes);
app.use("/api/therapists", therapistRoutes);

app.use("/api/resources", resourceRoutes);

app.use("/api/chat", chatRoutes);

app.use("/api/questions", questionRoutes);
app.use("/api/answers", answerRoutes);

app.use("/api/Payment", paymentRoutes);

app.use("/api/schedule", scheduleRoutes);


// Initialize database and Socket.IO
connectDB();
const io = initializeSocket(httpServer);
setIo(io); // Pass io to chat controller

// Start server
const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


export { io };

// app.use(session({
//     secret: "secret",
//     resave: false,
//     saveUninitialized:true
// }))
// app.use(passport.initialize());
// app.use(passport.session());

// passport.use(
//     new GoogleStrategy({
//         clientID: process.env.GOOGLE_CLIENT_ID,
//         clientSecret: process.env.GOOGLE_CLIENT_SECRET,
//         callbackURL: "http://localhost:3000/auth/google/callback",
        
//     },
//         (accessToken, refreshToken, profile, done) => {
//         return done(null,profile)
//     })
// )
// passport.serializeUser((user, done) => done(null, user));
// passport.deserializeUser((user, done) => done(null, user));

// app.get('/auth/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// app.get('/auth/google/callback', passport.authenticate('google'), (req, res) => {
//     // Redirect to your Mindally dashboard or user-specific page
//     res.redirect('/dashboard');
// });

// app.get('/dashboard', (req, res) => {
//     if (!req.isAuthenticated()) {
//         return res.redirect('/');
//     }
//     res.json({
//         message: `Welcome to Mindally, ${req.user.displayName}!`,
//         user: req.user,
//     });
// });

