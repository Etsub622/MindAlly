import nodeMailer from "nodemailer"

const sendEmail = async (email,otp) => {
 const transporter = nodeMailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'rediethaileab63@gmail.com',
        pass: 'senh rbqy joul rhzs'
    },tls: {
      rejectUnauthorized: false
    }
});

    const mailOptions = {
        from: "MindAlly <rediethaileab63@gmail.com>",
        to: email,
        subject: "verify your email",
        html: `<p> Enter ${otp} in the app to verify your email</p>`,
    };

    await transporter.sendMail(mailOptions);
};

export { sendEmail }