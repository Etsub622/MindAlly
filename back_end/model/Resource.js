import mongoose from "mongoose";

const options = { discriminatorKey: "type", timestamps: true };

// Base schema
const baseResourceSchema = new mongoose.Schema({}, options);

const Resource = mongoose.model("Resource", baseResourceSchema);

// Article schema
const ArticleSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  logo: { type: String, required: true },
  link: { type: String, required: true },
});

// Book schema
const BookSchema = new mongoose.Schema({

  image: { type: String, required: true },
  author: { type: String, required: true },
  title: { type: String, required: true },
});

// Video schema
const VideoSchema = new mongoose.Schema({
  image: { type: String, required: true },
  title: { type: String, required: true },
  link: { type: String, required: true },
  profilePicture: { type: String, required: true },
  name: { type: String, required: true },
});

const Article = Resource.discriminator("Article", ArticleSchema);
const Book = Resource.discriminator("Book", BookSchema);
const Video = Resource.discriminator("Video", VideoSchema);

export { Resource, Article, Book, Video };
