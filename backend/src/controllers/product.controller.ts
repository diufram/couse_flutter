import path from "path";
import sharp from "sharp";
import fs from "fs/promises";
import { Response } from "express";
import { prisma } from "../lib/prisma";
import { AuthRequest } from "../middleware/auth";

/**
 * 📁 Directorio base de imágenes
 */
const uploadsDir = path.join(process.cwd(), "uploads", "products");

/**
 * 🧾 Listar productos con filtros opcionales
 * ?q=texto&minPrice=100&maxPrice=500&onlyActive=true
 */
export const listProducts = async (req: AuthRequest, res: Response) => {
  const { q, minPrice, maxPrice, onlyActive } = req.query as any;

  const where: any = {};
  if (q) where.name = { contains: String(q), mode: "insensitive" };
  if (onlyActive === "true" || onlyActive === true) where.isActive = true;
  if (minPrice || maxPrice) {
    where.price = {};
    if (minPrice) where.price.gte = Number(minPrice);
    if (maxPrice) where.price.lte = Number(maxPrice);
  }

  const products = await prisma.product.findMany({
    where,
    orderBy: { createdAt: "desc" },
    select: {
      id: true,
      name: true,
      description: true,
      price: true,
      stock: true,
      imageUrl: true,
      isActive: true,
      createdAt: true,
      owner: { select: { id: true, name: true, email: true } },
    },
  });

  res.json(products);
};

/**
 * 📦 Obtener un producto por ID
 */
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
      owner: { select: { id: true, name: true, email: true } },
    },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  res.json(product);
};

/**
 * 🛒 Crear un nuevo producto
 */
export const createProduct = async (req: AuthRequest, res: Response) => {
  const { name, description, price, stock } = req.body;
  const newProduct = await prisma.product.create({
    data: {
      name,
      description,
      price,
      stock: stock ?? 0,
      ownerId: req.user!.id,
    },
  });
  res.status(201).json(newProduct);
};

/**
 * ✏️ Actualizar un producto existente
 */
export const updateProduct = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: { ownerId: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  if (product.ownerId !== req.user!.id)
    return res.status(403).json({ error: "No tienes permiso" });

  const { name, description, price, stock, isActive } = req.body;
  const updated = await prisma.product.update({
    where: { id },
    data: { name, description, price, stock, isActive },
  });
  res.json(updated);
};

/**
 * 🗑️ Eliminar un producto
 */
export const deleteProduct = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: { ownerId: true, imageKey: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  if (product.ownerId !== req.user!.id)
    return res.status(403).json({ error: "No tienes permiso" });

  // Borrar imagen asociada
  if (product.imageKey) {
    try {
      await fs.unlink(path.join(uploadsDir, product.imageKey));
    } catch {}
  }

  await prisma.product.delete({ where: { id } });
  res.status(204).send();
};

/**
 * 🖼️ Subir o reemplazar la imagen del producto
 */
export const uploadProductImage = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const file = (req as any).file as Express.Multer.File;
  if (!file) return res.status(400).json({ error: "Falta archivo 'image'" });

  const product = await prisma.product.findUnique({
    where: { id },
    select: { id: true, ownerId: true, imageKey: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  if (product.ownerId !== req.user!.id)
    return res.status(403).json({ error: "No tienes permiso" });

  // Convertir a .webp optimizado
  const outKey = file.filename.replace(path.extname(file.filename), ".webp");
  const outPath = path.join(uploadsDir, outKey);
  await sharp(file.path).resize(1200).webp({ quality: 85 }).toFile(outPath);

  // Borrar original temporal
  try {
    await fs.unlink(file.path);
  } catch {}

  // Borrar imagen anterior
  if (product.imageKey) {
    try {
      await fs.unlink(path.join(uploadsDir, product.imageKey));
    } catch {}
  }

  const stats = await fs.stat(outPath);
  const imageUrl = `/uploads/products/${outKey}`;

  const updated = await prisma.product.update({
    where: { id },
    data: {
      imageUrl,
      imageKey: outKey,
      mime: "image/webp",
      size: stats.size,
    },
    select: { id: true, imageUrl: true, mime: true, size: true },
  });

  res.json(updated);
};

/**
 * ❌ Eliminar imagen de un producto
 */
export const deleteProductImage = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const product = await prisma.product.findUnique({
    where: { id },
    select: { id: true, ownerId: true, imageKey: true },
  });

  if (!product) return res.status(404).json({ error: "Producto no encontrado" });
  if (product.ownerId !== req.user!.id)
    return res.status(403).json({ error: "No tienes permiso" });

  if (product.imageKey) {
    try {
      await fs.unlink(path.join(uploadsDir, product.imageKey));
    } catch {}
  }

  await prisma.product.update({
    where: { id },
    data: { imageUrl: null, imageKey: null, mime: null, size: null },
  });

  res.status(204).send();
};
