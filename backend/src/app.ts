import express from "express";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
import path from "path";

import authRoutes from "./routes/auth.routes";
import productRoutes from "./routes/product.routes";

dotenv.config();

export const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// Servir archivos subidos
app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

app.get("/", (_req, res) => res.json({ ok: true, name: "API Users & Products" }));
app.use("/auth", authRoutes);
app.use("/products", productRoutes);

// Manejo de errores
app.use((err: any, _req: any, res: any, _next: any) => {
  console.error(err);
  res.status(500).json({ error: "Error interno" });
});
