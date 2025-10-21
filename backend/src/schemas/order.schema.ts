import z from "zod";

export const orderCreateSchema = z.object({
  body: z.object({
    userId: z.coerce.number().int().positive().optional(), // opcional según tu flujo
    items: z
      .array(
        z.object({
          productId: z.coerce.number().int().positive(),
          quantity: z.coerce.number().int().min(1),
        })
      )
      .min(1, "Debe incluir al menos un item"),
  })
  // evitar productos duplicados (opcional)
  .refine(
    (b) => {
      const ids = b.items.map((i) => i.productId);
      return new Set(ids).size === ids.length;
    },
    { message: "No se permiten productos duplicados en items" }
  ),
});

// Obtener/operar por id
export const orderIdParamSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
});

// Filtro de pedidos (por usuario y rango de fechas)
export const orderQuerySchema = z.object({
  query: z
    .object({
      userId: z.coerce.number().int().positive().optional(),
      dateFrom: z.coerce.date().optional(),
      dateTo: z.coerce.date().optional(),
    })
    .refine(
      (q) => !q.dateFrom || !q.dateTo || q.dateFrom <= q.dateTo,
      { message: "dateFrom no puede ser mayor que dateTo" }
    ),
});