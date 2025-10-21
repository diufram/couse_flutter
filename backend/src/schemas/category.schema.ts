import z from "zod";

export const categoryCreateSchema = z.object({
  body: z.object({
    name: z.string().min(1),
    description: z.string().optional(),
  }),
});

export const categoryUpdateSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
  body: z
    .object({
      name: z.string().min(1).optional(),
      description: z.string().optional(),
    })
    .refine((d) => Object.keys(d).length > 0, { message: "Sin cambios" }),
});

export const categoryIdParamSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
});

export const categoryQuerySchema = z.object({
  query: z.object({
    q: z.string().optional(), // búsqueda por nombre/desc (server decide)
  }),
});
