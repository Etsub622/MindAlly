import express from "express";
import {
  addResource,
  getResources,
  getResourcesByType,
  updateResource,
  deleteResource,
  getResourceById,
  searchResources,
  getResourcesByCategory,
} from "../../controller/resource/resourceController.js";
import { validateResource } from "../../middlewares/validateResource.js";

const router = express.Router();

router.post("/", validateResource, addResource);
router.get("/", getResources);
router.get("/type/:type", getResourcesByType);
router.get("/search", searchResources); 
router.put("/:id", validateResource, updateResource);
router.delete("/:id", deleteResource);
router.get("/:id", getResourceById);
router.get("/category/:category", getResourcesByCategory);

export { router as resourceRoutes };
