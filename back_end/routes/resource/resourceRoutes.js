import express from "express";
import {
  addResource,
  getResources,
  getResourcesByType,
  updateResource,
  deleteResource,
} from "../../controller/resource/resourceController.js";
import { validateResource } from "../../middlewares/validateResource.js";

const router = express.Router();

router.post("/", validateResource, addResource);
router.get("/", getResources);
router.get("/type/:type", getResourcesByType);
router.put("/:id", validateResource, updateResource);
router.delete("/:id", deleteResource);
router.get("/:id", getResourceById);

export { router as resourceRoutes };
