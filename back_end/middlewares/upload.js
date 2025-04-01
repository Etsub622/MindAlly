import multer from "multer";
import path from "path";

// Configure storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "uploads/"); // Store images in 'uploads' folder
    },
    // filename: (req, file, cb) => {
    //     cb(null, `${Date.now()}_${file.originalname}`);
    // }
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname)); // Unique filename
      },
});

// File filter to allow only images
const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith("image/")) {
        cb(null, true);
    } else {
        cb(new Error("Only image files are allowed"), false);
    }
};

// Upload middleware
const upload = multer({ storage, fileFilter });

export default upload;
