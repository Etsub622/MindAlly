
import jwt from "jsonwebtoken";


export const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization;
    if (!authHeader) return res.sendStatus(401);
    console.log('Authorization Header:', req.headers.authorization);

  const token = authHeader.split(" ")[1];
  jwt.verify(token, process.env.ACCESS_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user; 
    console.log(err)
      console.log(token)
      console.log(user)
    next();
  });
};
