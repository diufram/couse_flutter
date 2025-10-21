// prisma/seed.ts
import "dotenv/config";
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function upsertUsers() {
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
  return { u1, u2 };
}

async function upsertCategories() {
  // Como Category.name es único, podemos usar upsert seguro
  const [catElec, catHogar, catAcc] = await Promise.all([
    prisma.category.upsert({
      where: { name: "Electrónica" },
      update: {},
      create: { name: "Electrónica", description: "Dispositivos y gadgets" },
    }),
    prisma.category.upsert({
      where: { name: "Hogar" },
      update: {},
      create: { name: "Hogar", description: "Artículos para el hogar" },
    }),
    prisma.category.upsert({
      where: { name: "Accesorios" },
      update: {},
      create: { name: "Accesorios", description: "Periféricos y extras" },
    }),
  ]);
  return { catElec, catHogar, catAcc };
}

async function resetSampleProducts() {
  // Elimina solo los productos del set de ejemplo (idempotente)
  await prisma.orderItem.deleteMany({});
  await prisma.order.deleteMany({}); // para no dejar FK colgando
  await prisma.product.deleteMany({
    where: {
      name: { in: ["Cafetera Compact", "Auriculares Inalámbricos", "Teclado Mecánico 60%"] },
    },
  });
}

async function createSampleProducts(cats: {
  catElec: { id: number };
  catHogar: { id: number };
  catAcc: { id: number };
}) {
  const products = await prisma.$transaction([
    prisma.product.create({
      data: {
        name: "Cafetera Compact",
        description: "Cafetera de goteo 600ml",
        imageUrl: "https://picsum.photos/seed/cafetera/600/400",
        price: 249.9,
        stock: 12,
        isActive: true,
        categoryId: cats.catHogar.id,
      },
    }),
    prisma.product.create({
      data: {
        name: "Auriculares Inalámbricos",
        description: "BT 5.3 con estuche",
        imageUrl: "https://picsum.photos/seed/earbuds/600/400",
        price: 179.5,
        stock: 30,
        isActive: true,
        categoryId: cats.catElec.id,
      },
    }),
    prisma.product.create({
      data: {
        name: "Teclado Mecánico 60%",
        description: "Switches rojos, RGB",
        imageUrl: "https://picsum.photos/seed/keyboard/600/400",
        price: 349.0,
        stock: 8,
        isActive: true,
        categoryId: cats.catAcc.id,
      },
    }),
  ]);
  return products;
}

function calc(items: { quantity: number; unitPrice: number }[]) {
  const subtotal = items.reduce((acc, it) => acc + it.quantity * it.unitPrice, 0);
  const total = subtotal; // sin impuestos/envío/desc. en tu modelo minimal
  return { subtotal, total };
}

async function createSampleOrder(userId: number, products: any[]) {
  // Tomamos 2 productos para el pedido
  const p1 = products.find((p) => p.name === "Auriculares Inalámbricos");
  const p2 = products.find((p) => p.name === "Cafetera Compact");

  const orderItemsInput = [
    { productId: p1.id, quantity: 2, unitPrice: Number(p1.price) },
    { productId: p2.id, quantity: 1, unitPrice: Number(p2.price) },
  ];

  const { subtotal, total } = calc(orderItemsInput);

  // Crea Order y OrderItems (en tu esquema: Order tiene createdAt, subtotal, total)
  const order = await prisma.order.create({
    data: {
      userId,
      subtotal,
      total,
      items: {
        create: orderItemsInput.map((i) => ({
          productId: i.productId,
          quantity: i.quantity,
          // En tu modelo OrderItem solo existe `subtotal` (no `unitPrice`)
          subtotal: i.quantity * i.unitPrice,
        })),
      },
    },
    include: { items: true },
  });

  return order;
}

async function main() {
  const { u1, u2 } = await upsertUsers();
  const cats = await upsertCategories();
  await resetSampleProducts();
  const products = await createSampleProducts(cats);

  // Pedido de ejemplo para el usuario Demo
  const order = await createSampleOrder(u1.id, products);

  console.log("✅ Seed listo:");
  console.table([
    { user: u1.email, pedidos: 1, totalPedido: Number(order.total).toFixed(2) },
    { user: u2.email, pedidos: 0, totalPedido: "-" },
  ]);
}

main()
  .catch((e) => {
    console.error("❌ Error seed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
