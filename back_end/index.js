import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import userRoutes from "./routes/authenticaionRoutes/userAuth.js"
import otpRoutes from "./routes/authenticaionRoutes/otpRoutes.js"
import googleRoutes from "./routes/authenticaionRoutes/loginwithGoogle.js"
// import session from "express-session";
// import passport from "passport";
// import { Strategy as GoogleStrategy } from "passport-google-oauth20";


 


dotenv.config();
const app = express();
app.use(bodyParser.json());


mongoose
    .connect(process.env.Mongo_url)
    .then(() => {
        console.log("Database connected succesfully")
    })

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



app.get('/', (req, res) => {
    res.send("<a href='/api/google/authgoogle'> login with google </a>")
})
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













app.use(cors({
 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
  credentials:true
}));


app.use("/api/user", userRoutes)
app.use("/api/otp", otpRoutes)
app.use("/api/google",googleRoutes)


app.listen(process.env.PORT, () => {
    console.log(   `server is running on port ${process.env.PORT}`)
})

