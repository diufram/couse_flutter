import { app } from "./app";

const port = process.env.PORT || 3000;
// ✨ Cambia aquí
const host = "0.0.0.0"; // Escucha en toda la red, no solo localhost

app.listen(Number(port), host, () => {
  console.log(`🚀 API corriendo en http://${host}:${port}`);
});
