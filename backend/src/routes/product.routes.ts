import { Router } from "express";
import { auth } from "../middleware/auth";
import { validate } from "../middleware/validate";
import {
  productCreateSchema,
  productUpdateSchema,
  productIdParamSchema,
  productQuerySchema,
} from "../schemas/product.schema";
import {
  createProduct,
  deleteProduct,
  getProduct,
  listProducts,
  updateProduct,
} from "../controllers/product.controller";
import { uploadImage } from "../middleware/upload";
import { uploadProductImage, deleteProductImage } from "../controllers/product.controller";

const r = Router();

r.get("/", validate(productQuerySchema), listProducts);
r.get("/:id", validate(productIdParamSchema), getProduct);

r.post("/", auth, validate(productCreateSchema), createProduct);
r.put("/:id", auth, validate(productUpdateSchema), updateProduct);
r.delete("/:id", auth, validate(productIdParamSchema), deleteProduct);

// ⬇️ Subir / borrar imagen
r.post("/:id/image", auth, validate(productIdParamSchema), uploadImage.single("image"), uploadProductImage);
r.delete("/:id/image", auth, validate(productIdParamSchema), deleteProductImage);

export default r;
