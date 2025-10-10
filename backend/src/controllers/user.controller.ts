import { Request, Response } from "express";
import { prisma } from "../lib/prisma";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { AuthRequest } from "../middleware/auth";

export const register = async (req: Request, res: Response) => {
  const { email, name, password } = req.body;
  const exists = await prisma.user.findUnique({ where: { email } });
  if (exists) return res.status(409).json({ error: "Email ya registrado" });

  const hash = await bcrypt.hash(password, 10);
  const user = await prisma.user.create({
    data: { email, name, password: hash },
    select: { id: true, email: true, name: true, createdAt: true },
  });
  return res.status(201).json(user);
};

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) return res.status(401).json({ error: "Credenciales inválidas" });

  const ok = await bcrypt.compare(password, user.password);
  if (!ok) return res.status(401).json({ error: "Credenciales inválidas" });

  const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET!, { expiresIn: "7d" });
  return res.json({ token });
};

export const me = async (req: AuthRequest, res: Response) => {
  const user = await prisma.user.findUnique({
    where: { id: req.user!.id },
    select: { id: true, email: true, name: true, createdAt: true },
  });
  res.json(user);
};

// (Opcional) listar/obtener/actualizar usuarios (protegidos)
export const listUsers = async (_req: AuthRequest, res: Response) => {
  const users = await prisma.user.findMany({
    select: { id: true, email: true, name: true, createdAt: true },
    orderBy: { createdAt: "desc" },
  });
  res.json(users);
};

export const getUser = async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const user = await prisma.user.findUnique({
    where: { id },
    select: { id: true, email: true, name: true, createdAt: true },
  });
  if (!user) return res.status(404).json({ error: "No encontrado" });
  res.json(user);
};

export const updateUser = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  // Solo permitir que el propio usuario se actualice (o aquí podrías validar rol)
  if (req.user!.id !== id) return res.status(403).json({ error: "Prohibido" });

  const { name, password } = req.body;
  const data: any = {};
  if (name) data.name = name;
  if (password) data.password = await bcrypt.hash(password, 10);

  const user = await prisma.user.update({
    where: { id },
    data,
    select: { id: true, email: true, name: true, createdAt: true },
  });
  res.json(user);
};
