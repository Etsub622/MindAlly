// import session from "express-session";
// import passport from "passport";
// import { Strategy as GoogleStrategy } from "passport-google-oauth20";
// import express from "express";
// import dotenv from 'dotenv';
// dotenv.config();


// const app = express()


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



// app.get('/', (req, res) => {
//     res.send("<a href='/auth/google'> login with google </a>")
// })


// const authGoogle = async (req, res, next) => {
//     try {
//         passport.authenticate('google', { scope: ['profile', 'email'] })(req, res, next);
//     } catch (err) {
//         res.status(500).json({ err: "An error occurred" });
//     }
// };

// const googleCallback = async (req, res, next) => {
//     try {
//         passport.authenticate('google', (err, user) => {
//             if (err || !user) {
//                 return res.redirect('/'); 
//             }
            
//             req.logIn(user, (loginErr) => {
//                 if (loginErr) {
//                     return next(loginErr); 
//                 }
//                 res.redirect('/dashboard');
//             });
//         })(req, res, next);
//     } catch (err) {
//         res.status(500).json({ err: "An error occurred during Google callback" });
//     }
// };

// const getDashboard = async (req, res) => {
//     try {
//         if (!req.isAuthenticated()) {
//             return res.redirect('/'); 
//         }
//         res.json({
//             message: `Welcome to Mindally, ${req.user.displayName}!`,
//             user: req.user,
//         });
//     } catch (err) {
//         res.status(500).json({ err: "An error occurred while loading the dashboard" });
//     }
// };

// export {authGoogle , googleCallback , getDashboard}


