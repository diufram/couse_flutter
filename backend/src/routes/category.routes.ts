import { Router } from "express";
import * as Categories from "../controllers/categories.controller";

const r = Router();

r.get("/", Categories.listCategories);
r.post("/", Categories.createCategory);
r.put("/:id", Categories.updateCategory);
r.delete("/:id", Categories.deleteCategory);
export default r;
