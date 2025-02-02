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

export const updateResource = async (req, res) => {
  try {
    const updatedResource = await Resource.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedResource) {
      return res.status(404).json({ error: "Resource not found" });
    }
    res.status(200).json(updatedResource);
  } catch (error) {
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

