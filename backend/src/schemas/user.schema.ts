import { z } from "zod";

/* =========================
 *         USERS
 * ========================= */
export const registerSchema = z.object({
  body: z.object({
    email: z.string().email(),
    name: z.string().min(2),
    password: z.string().min(6),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(6),
  }),
});

export const userIdParamSchema = z.object({
  params: z.object({
    id: z.string().regex(/^\d+$/),
  }),
});

export const userUpdateSchema = z.object({
  params: z.object({ id: z.string().regex(/^\d+$/) }),
  body: z
    .object({
      name: z.string().min(2).optional(),
      password: z.string().min(6).optional(),
    })
    .refine((d) => Object.keys(d).length > 0, { message: "Sin cambios" }),
});
