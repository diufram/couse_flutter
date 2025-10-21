import z from "zod";

export const productCreateSchema = z.object({
  body: z.object({
    name: z.string().min(1),
    description: z.string().optional(),
    imageUrl: z.string().url().optional(),
    price: z.coerce.number().nonnegative(),
    stock: z.coerce.number().int().min(0).default(0),
    categoryId: z.coerce.number().int().positive(), // requerido por el modelo
  }),
});

export const productUpdateSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
  body: z
    .object({
      name: z.string().min(1).optional(),
      description: z.string().optional(),
      imageUrl: z.string().url().optional(),
      price: z.coerce.number().nonnegative().optional(),
      stock: z.coerce.number().int().min(0).optional(),
      isActive: z.boolean().optional(),
      categoryId: z.coerce.number().int().positive().optional(),
    })
    .refine((d) => Object.keys(d).length > 0, { message: "Sin cambios" }),
});

export const productIdParamSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
});

export const productQuerySchema = z.object({
  query: z
    .object({
      q: z.string().optional(),
      minPrice: z.coerce.number().nonnegative().optional(),
      maxPrice: z.coerce.number().nonnegative().optional(),
      onlyActive: z.coerce.boolean().optional(),
      categoryId: z.coerce.number().int().positive().optional(),
    })
    .refine(
      (q) => !q.minPrice || !q.maxPrice || q.minPrice <= q.maxPrice,
      { message: "minPrice no puede ser mayor que maxPrice" }
    ),
});
