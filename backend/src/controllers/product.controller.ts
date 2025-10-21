// controllers/products.controller.ts
import path from "path";
import sharp from "sharp";
import fs from "fs/promises";
import { Response } from "express";
import { prisma } from "../lib/prisma";
import { AuthRequest } from "../middleware/auth";

const uploadsDir = path.join(process.cwd(), "uploads", "products");

/** Listar productos (?q, minPrice, maxPrice, onlyActive, categoryId) */
export const listProducts = async (req: AuthRequest, res: Response) => {
  const { q, minPrice, maxPrice, onlyActive, categoryId } = req.query as any;

  const where: any = {};
  if (q) where.name = { contains: String(q), mode: "insensitive" };
  if (onlyActive === "true" || onlyActive === true) where.isActive = true;
  if (minPrice || maxPrice) {
    where.price = {};
    if (minPrice) where.price.gte = Number(minPrice);
    if (maxPrice) where.price.lte = Number(maxPrice);
  }
  if (categoryId) where.categoryId = Number(categoryId);

  const products = await prisma.product.findMany({
    where,
    orderBy: { createdAt: "desc" },
    include: {
      category: true, // 🔥 Trae TODO el objeto de la categoría
    }
  });

  res.json(products);
};

/** Obtener producto por ID */
export const getProduct = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: {
      id: true,
      name: true,
      description: true,
      price: true,
      stock: true,
      imageUrl: true,
      isActive: true,
      createdAt: true,
      category: { select: { id: true, name: true } },
    },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  res.json(product);
};

/** Crear producto (categoryId requerido) */
export const createProduct = async (req: AuthRequest, res: Response) => {
  const { name, description, price, stock, categoryId, isActive } = req.body;

  const category = await prisma.category.findUnique({ where: { id: Number(categoryId) } });
  if (!category) return res.status(400).json({ error: "categoryId inválido" });

  const newProduct = await prisma.product.create({
    data: {
      name,
      description,
      price: Number(price),
      stock: stock ?? 0,
      categoryId: Number(categoryId),
      isActive: typeof isActive === "boolean" ? isActive : true,
    },
  });
  res.status(201).json(newProduct);
};

/** Actualizar producto */
export const updateProduct = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const exists = await prisma.product.findUnique({ where: { id }, select: { id: true } });
  if (!exists) return res.status(404).json({ error: "Producto no encontrado" });

  const { name, description, price, stock, isActive, categoryId } = req.body;

  if (categoryId) {
    const cat = await prisma.category.findUnique({ where: { id: Number(categoryId) } });
    if (!cat) return res.status(400).json({ error: "categoryId inválido" });
  }

  const updated = await prisma.product.update({
    where: { id },
    data: {
      name,
      description,
      price: price !== undefined ? Number(price) : undefined,
      stock,
      isActive,
      categoryId: categoryId ? Number(categoryId) : undefined,
    },
  });
  res.json(updated);
};

/** Eliminar producto (borra imagen si existe) */
export const deleteProduct = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: { id: true, imageUrl: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });

  if (product.imageUrl) {
    try {
      const filename = path.basename(product.imageUrl);
      await fs.unlink(path.join(uploadsDir, filename));
    } catch { }
  }

  await prisma.product.delete({ where: { id } });
  res.status(204).send();
};

/** Subir/Reemplazar imagen del producto (solo imageUrl en DB) */
export const uploadProductImage = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const file = (req as any).file as Express.Multer.File;
  if (!file) return res.status(400).json({ error: "Falta archivo 'image'" });

  const product = await prisma.product.findUnique({
    where: { id },
    select: { id: true, imageUrl: true },
  });
  if (!product) return res.status(404).json({ error: "Producto no encontrado" });

  await fs.mkdir(uploadsDir, { recursive: true });

  const outKey = file.filename.replace(path.extname(file.filename), ".webp");
  const outPath = path.join(uploadsDir, outKey);

  await sharp(file.path).resize(1200).webp({ quality: 85 }).toFile(outPath);
  try { await fs.unlink(file.path); } catch { }

  if (product.imageUrl) {
    try {
      const prev = path.join(uploadsDir, path.basename(product.imageUrl));
      await fs.unlink(prev);
    } catch { }
  }

  const imageUrl = `/uploads/products/${outKey}`;
  const updated = await prisma.product.update({
    where: { id },
    data: { imageUrl },
    select: { id: true, imageUrl: true },
  });

  res.json(updated);
};

/** Eliminar solo la imagen del producto */
export const deleteProductImage = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: { id: true, imageUrl: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });

  if (product.imageUrl) {
    try {
      const filepath = path.join(uploadsDir, path.basename(product.imageUrl));
      await fs.unlink(filepath);
    } catch { }
  }

  await prisma.product.update({
    where: { id },
    data: { imageUrl: null },
  });

  res.status(204).send();
};
