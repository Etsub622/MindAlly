import Joi from "joi";

const articleValidationSchema = Joi.object({
  type: Joi.string().valid("Article").required(),
  title: Joi.string().required(),
  content: Joi.string().required(),
  logo: Joi.string().required(),
  link: Joi.string().uri().required(),
  categories: Joi.array().items(Joi.string()).min(1).required(),
  ownerId: Joi.string().required(), 
});

const bookValidationSchema = Joi.object({
  type: Joi.string().valid("Book").required(),
  image: Joi.string().required(),
  author: Joi.string().required(),
  title: Joi.string().required(),
  categories: Joi.array().items(Joi.string()).min(1).required(),
  ownerId: Joi.string().required() 
});

const videoValidationSchema = Joi.object({
  type: Joi.string().valid("Video").required(),
  image: Joi.string().required(),
  title: Joi.string().required(),
  link: Joi.string().uri().required(),
  profilePicture: Joi.string().required(),
  name: Joi.string().required(),
  categories: Joi.array().items(Joi.string()).min(1).required(),
  ownerId: Joi.string().required(),
});

export { articleValidationSchema, bookValidationSchema, videoValidationSchema };
