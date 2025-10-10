# 📦 API de Usuarios y Productos (Node.js + Express + Prisma)

Este proyecto es una API REST básica que incluye autenticación JWT, manejo de usuarios, productos y subida de imágenes.  
Está desarrollada con **Node.js + Express + TypeScript + Prisma**.

---

## 🧩 Tecnologías

- **Node.js** (Runtime)
- **Express** (Framework HTTP)
- **Prisma ORM** (SQLite o PostgreSQL)
- **JWT** (Autenticación)
- **Multer + Sharp** (Subida y optimización de imágenes)
- **Zod** (Validaciones)

---

## ⚙️ Instalación y configuración

### 1️⃣ Clonar e instalar dependencias

```bash
npm install

# 🌐 Configuración general
PORT=3000
JWT_SECRET="clave-super-secreta"

# 🗄️ Base de datos Postgres (por defecto)
DATABASE_URL="postgresql://USER:PASSWORD@HOST:5432/DBNAME?schema=public"

# 🔹 Generar el cliente Prisma (debe hacerse tras cada cambio en schema.prisma)
npx prisma generate

# 🔹 Crear la primera migración y base de datos
npx prisma migrate dev --name init

# 🔹 Ver el estado de la base de datos en GUI
npx prisma studio

# 🔥 Borra todas las tablas, aplica migraciones y ejecuta prisma/seed.ts
npx prisma migrate reset

# 🧹 Vaciar base de datos sin eliminar migraciones
npx prisma db push --force-reset

# 🌱 Ejecutar manualmente el archivo de seed
npx prisma db seed
