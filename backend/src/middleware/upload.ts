import multer, { FileFilterCallback } from "multer";
import path from "path";
import fs from "fs";

const baseDir = path.join(process.cwd(), "uploads", "products");
fs.mkdirSync(baseDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null as any, baseDir),
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const name = `${Date.now()}-${Math.random().toString(36).slice(2)}${ext}`;
    cb(null as any, name);
  },
});

// Usa FileFilterCallback y NO pases null (o castea explícitamente)
const fileFilter = (_req: Express.Request, file: Express.Multer.File, cb: FileFilterCallback) => {
  const ok = /image\/(jpeg|png|webp)/.test(file.mimetype);
  if (!ok) {
    cb(new Error("Formato no permitido (jpg/png/webp)"));
    return;
  }
  cb(null as any, true); // <- algunos tipos exigen Error, casteamos a any
};

export const uploadImage = multer({
  storage,
  fileFilter,
  limits: { fileSize: 3 * 1024 * 1024 }, // 3MB
});
