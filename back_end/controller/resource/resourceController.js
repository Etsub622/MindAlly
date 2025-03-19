import { Resource } from "../../model/Resource.js";

export const addResource = async (req, res) => {
  try {
    
    const resource = new Resource(req.body);
    const savedResource = await resource.save();
    res.status(201).json(savedResource);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const getResources = async (req, res) => {
  try {
    const resources = await Resource.find(req.query);
    res.status(200).json(resources);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getResourcesByType = async (req, res) => {
  try {
    const { type } = req.params;
    const resources = await Resource.find({ type });
    if (!resources.length) {
      return res.status(404).json({ message: `No resources found for type: ${type}` });
    }
    res.status(200).json(resources);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getResourceById = async (req, res) => {
  try {
    const resource = await Resource.findById(req.params.id);
    if (!resource) {
      return res.status(404).json({ error: "Resource not found" });
    }
    res.status(200).json(resource);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateResource = async (req, res) => {
  try {
    console.log("Received update request for ID:", req.params.id);
    console.log("Request body:", req.body);

    let resource = await Resource.findById(req.params.id);

    if (!resource) {
      console.log("Resource not found!");
      return res.status(404).json({ error: "Resource not found" });
    }

    // Merge only provided fields (skip undefined fields)
    Object.keys(req.body).forEach((key) => {
      if (req.body[key] !== undefined) {
        resource[key] = req.body[key];
      }
    });

    // Save the updated resource
    const updatedResource = await resource.save();

    console.log("Updated Resource:", updatedResource);
    res.status(200).json(updatedResource);
  } catch (error) {
    console.log("Error updating resource:", error.message);
    res.status(400).json({ error: error.message });
  }
};

export const deleteResource = async (req, res) => {
  try {
    const deletedResource = await Resource.findByIdAndDelete(req.params.id);
    if (!deletedResource) {
      return res.status(404).json({ error: "Resource not found" });
    }
    res.status(200).json({ message: "Resource deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const searchResources = async (req, res) => {
  try {
    const { query } = req.query;

    if (!query) {
      return res.status(400).json({ error: "Search query is required" });
    }

    console.log("Searching for (case-insensitive):", query);

    // Use regex with "i" option to make search case-insensitive
    const searchCriteria = {
      $or: [
        { title: { $regex: new RegExp(query, "i") } }, // Case-insensitive title search
        { author: { $regex: new RegExp(query, "i") } }, // Case-insensitive book author search
        { name: { $regex: new RegExp(query, "i") } }, // Case-insensitive video name search
      ],
    };

    const results = await Resource.find(searchCriteria);

    if (!results.length) {
      return res.status(404).json({ message: "No matching resources found." });
    }

    console.log("Search results:", results);
    res.status(200).json(results);
  } catch (error) {
    console.error("Error searching resources:", error.message);
    res.status(500).json({ error: error.message });
  }
};


export const getResourcesByCategory = async (req, res) => {
  try {
    const { category } = req.params;

    console.log("Fetching resources for category (case-insensitive):", category);

    // Use regex to make search case-insensitive
    const resources = await Resource.find({ categories: { $regex: new RegExp(category, "i") } });

    if (!resources.length) {
      return res.status(404).json({ message: `No resources found under category: ${category}` });
    }

    console.log("Resources found:", resources);
    res.status(200).json(resources);
  } catch (error) {
    console.error("Error fetching resources by category:", error.message);
    res.status(500).json({ error: error.message });
  }
};

