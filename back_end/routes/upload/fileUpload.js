import express from "express";
import multer from "multer";
import path from "path";
import fs from "fs";

const router = express.Router();

// Configure multer storage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const userId = req.params.userId;
    const dir = `uploads/${userId}`;

    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    cb(null, dir);
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

// POST /api/upload/:userId
router.post("/:userId", upload.array("files"), (req, res) => {
  const userId = req.params.userId;
  const fileUrls = req.files.map(file => {
    return `${req.protocol}://${req.get("host")}/uploads/${userId}/${file.filename}`;
  });

  res.status(200).json({
    message: "Files uploaded successfully",
    urls: fileUrls,
  });
});

export default router;



// import express from "express";
// import multer from "multer";
// import path from "path";
// import fs from "fs";

// const router = express.Router();

// // Create upload directory if not exists
// const uploadDir = "uploads/";
// if (!fs.existsSync(uploadDir)) {
//   fs.mkdirSync(uploadDir);
// }

// // Configure multer storage
// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, uploadDir);
//   },
//   filename: function (req, file, cb) {
//     const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
//     const ext = path.extname(file.originalname);
//     cb(null, file.fieldname + "-" + uniqueSuffix + ext);
//   }
// });

// const upload = multer({ storage: storage });

// // Upload endpoint
// router.post("/", upload.single("file"), (req, res) => {
//   if (!req.file) {
//     return res.status(400).json({ message: "No file uploaded" });
//   }

//   const fileUrl = `${req.protocol}://${req.get("host")}/uploads/${req.file.filename}`;
//   res.status(201).json({
//     message: "File uploaded successfully",
//     fileUrl,
//   });
// });

// export default router;