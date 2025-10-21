// controllers/categories.controller.ts
import { Request, Response } from "express";
import { prisma } from "../lib/prisma";

export const listCategories = async (_req: Request, res: Response) => {
  const cats = await prisma.category.findMany({
    orderBy: { name: "asc" },
    select: { id: true, name: true, description: true, createdAt: true },
  });
  res.json(cats);
};

export const createCategory = async (req: Request, res: Response) => {
  const { name, description } = req.body;
  const exists = await prisma.category.findUnique({ where: { name } });
  if (exists) return res.status(409).json({ error: "Nombre ya existe" });

  const cat = await prisma.category.create({ data: { name, description } });
  res.status(201).json(cat);
};

export const updateCategory = async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const { name, description } = req.body;

  const exists = await prisma.category.findUnique({ where: { id } });
  if (!exists) return res.status(404).json({ error: "Categoría no encontrada" });

  if (name) {
    const dupe = await prisma.category.findUnique({ where: { name } });
    if (dupe && dupe.id !== id) return res.status(409).json({ error: "Nombre ya existe" });
  }

  const cat = await prisma.category.update({
    where: { id },
    data: { name, description },
  });
  res.json(cat);
};

export const deleteCategory = async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  // Si hay productos asociados, el FK (Restrict) impedirá eliminar
  try {
    await prisma.category.delete({ where: { id } });
    res.status(204).send();
  } catch {
    res.status(400).json({ error: "No se puede eliminar: tiene productos asociados" });
  }
};
