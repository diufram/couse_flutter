// prisma/seed.ts
import "dotenv/config";
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  // 1) Usuarios (idempotente)
  const [u1, u2] = await Promise.all([
    prisma.user.upsert({
      where: { email: "demo@demo.com" },
      update: {},
      create: {
        email: "demo@demo.com",
        name: "Demo",
        password: await bcrypt.hash("secret123", 10),
      },
    }),
    prisma.user.upsert({
      where: { email: "vendedor@shop.com" },
      update: {},
      create: {
        email: "vendedor@shop.com",
        name: "Vendedor",
        password: await bcrypt.hash("vendedor123", 10),
      },
    }),
  ]);

  // 2) Limpiar productos del vendedor (para repetir el seed ordenadamente)
  await prisma.product.deleteMany({ where: { ownerId: u2.id } });

  // 3) Productos de ejemplo
  await prisma.product.createMany({
    data: [
      {
        name: "Cafetera Compact",
        description: "Cafetera de goteo 600ml",
        imageUrl: "https://picsum.photos/seed/cafetera/600/400",
        price: 249.90,
        stock: 12,
        isActive: true,
        ownerId: u2.id,
      },
      {
        name: "Auriculares Inalámbricos",
        description: "BT 5.3 con estuche",
        imageUrl: "https://picsum.photos/seed/earbuds/600/400",
        price: 179.50,
        stock: 30,
        isActive: true,
        ownerId: u2.id,
      },
      {
        name: "Teclado Mecánico 60%",
        description: "Switches rojos, RGB",
        imageUrl: "https://picsum.photos/seed/keyboard/600/400",
        price: 349.00,
        stock: 8,
        isActive: true,
        ownerId: u2.id,
      },
    ],
  });

  console.log("✅ Seed mínimo listo:", {
    users: [u1.email, u2.email],
    productsFor: u2.email,
  });
}

main()
  .catch((e) => {
    console.error("❌ Error seed:", e);
    process.exit(1);
  })
  .finally(async () => prisma.$disconnect());
