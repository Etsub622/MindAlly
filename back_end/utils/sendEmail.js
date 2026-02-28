import nodeMailer from "nodemailer";

const sendEmail = async (email, subject, html) => {
  const transporter = nodeMailer.createTransport({
    service: "gmail",
    auth: {
      user: "etsubdinkawoke@gmail.com",
      pass: "jfhx swbq niuo hqea",
    },
    tls: {
      rejectUnauthorized: false,
    },
  });

  const mailOptions = {
    from: "MindAlly <etsubdinkawoke@gmail.com>",
    to: email,
    subject: subject,
    html: html,
  };

  await transporter.sendMail(mailOptions);
};

export { sendEmail };
