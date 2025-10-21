// controllers/orders.controller.ts
import { Response } from "express";
import { prisma } from "../lib/prisma";
import { AuthRequest } from "../middleware/auth";

/**
 * Crea un pedido con items { productId, quantity }
 * - Calcula subtotal por item y del pedido
 * - Opcional: descuenta stock (puedes habilitarlo)
 */
export const createOrder = async (req: AuthRequest, res: Response) => {
  const { items, userId } = req.body as {
    userId?: number;
    items: { productId: number; quantity: number }[];
  };

  if (!Array.isArray(items) || items.length < 1)
    return res.status(400).json({ error: "Debe incluir items" });

  // Cargar productos y validar
  const productIds = items.map((i) => Number(i.productId));
  const dbProducts = await prisma.product.findMany({
    where: { id: { in: productIds }, isActive: true },
    select: { id: true, price: true, stock: true, name: true },
  });
  if (dbProducts.length !== items.length)
    return res.status(400).json({ error: "Algún productId es inválido o inactivo" });

  // Calcular subtotales
  const enriched = items.map((it) => {
    const p = dbProducts.find((dp) => dp.id === Number(it.productId))!;
    const qty = Number(it.quantity);
    if (qty < 1) throw new Error("quantity inválido");
    return {
      productId: p.id,
      quantity: qty,
      subtotal: Number(p.price) * qty, // en tu modelo OrderItem solo guardas subtotal
      priceAtOrder: Number(p.price),   // (sólo para cálculo, no se guarda)
      nameAtOrder: p.name,             // (opcional: no se guarda)
      stock: p.stock,
    };
  });

  // (Opcional) validar stock
  // for (const it of enriched) {
  //   if (it.quantity > it.stock) {
  //     return res.status(400).json({ error: `Sin stock para producto ${it.productId}` });
  //   }
  // }

  const orderSubtotal = enriched.reduce((acc, it) => acc + it.subtotal, 0);
  const orderTotal = orderSubtotal; // minimal model

  // Transacción
  const order = await prisma.$transaction(async (tx) => {
    const created = await tx.order.create({
      data: {
        userId: userId ?? req.user?.id ?? null,
        subtotal: orderSubtotal,
        total: orderTotal,
        items: {
          create: enriched.map((it) => ({
            productId: it.productId,
            quantity: it.quantity,
            subtotal: it.subtotal,
          })),
        },
      },
      include: { items: true },
    });

    // (Opcional) descontar stock
    // for (const it of enriched) {
    //   await tx.product.update({
    //     where: { id: it.productId },
    //     data: { stock: { decrement: it.quantity } },
    //   });
    // }

    return created;
  });

  res.status(201).json(order);
};

/** Obtener un pedido por id (incluye items y productos) */
export const getOrder = async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const order = await prisma.order.findUnique({
    where: { id },
    include: { 
      user: { select: { id: true, email: true, name: true } },
      items: { include: { product: { select: { id: true, name: true, price: true, imageUrl: true } } } },
    },
  });
  if (!order) return res.status(404).json({ error: "Pedido no encontrado" });
  res.json(order);
};

/** Listar pedidos (por userId y/o rango de fechas) */
export const listOrders = async (req: AuthRequest, res: Response) => {
  const { userId, dateFrom, dateTo } = req.query as any;
  const where: any = {};
  if (userId) where.userId = Number(userId);
  if (dateFrom || dateTo) {
    where.createdAt = {};
    if (dateFrom) where.createdAt.gte = new Date(dateFrom);
    if (dateTo) where.createdAt.lte = new Date(dateTo);
  }

  const orders = await prisma.order.findMany({
    where,
    orderBy: { createdAt: "desc" },
    include: {
      user: { select: { id: true, email: true, name: true } },
      items: true,
    },
  });
  res.json(orders);
};
