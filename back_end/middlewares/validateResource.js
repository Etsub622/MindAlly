import {
  articleValidationSchema,
  bookValidationSchema,
  videoValidationSchema,
} from "../validations/resourceValidation.js";

export const validateResource = (req, res, next) => {
  const { type } = req.body;
  let schema;

  switch (type) {
    case "Article":
      schema = articleValidationSchema;
      break;
    case "Book":
      schema = bookValidationSchema;
      break;
    case "Video":
      schema = videoValidationSchema;
      break;
    default:
      return res.status(400).json({ error: "Invalid resource type" });
  }

  const { error } = schema.validate(req.body);
  if (error) {
    return res.status(400).json({ error: error.details[0].message });
  }
  next();
};
