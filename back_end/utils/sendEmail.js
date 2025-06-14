import nodeMailer from "nodemailer"

const sendEmail = async (email, subject, html) => {
  const transporter = nodeMailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'rediethaileab63@gmail.com',
      pass: 'jfhx swbq niuo hqea'
    },
    tls: {
      rejectUnauthorized: false
    }
  });

  const mailOptions = {
    from: "MindAlly <rediethaileab63@gmail.com>",
    to: email,
    subject: subject,
    html: html,
  };

  await transporter.sendMail(mailOptions);
};

export { sendEmail }