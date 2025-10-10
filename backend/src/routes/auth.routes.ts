import { Router } from "express";
import { register, login, me, listUsers, getUser, updateUser } from "../controllers/user.controller";
import { validate } from "../middleware/validate";
import { registerSchema, loginSchema, userIdParamSchema, userUpdateSchema } from "../schemas/user.schema";
import { auth } from "../middleware/auth";

const r = Router();

r.post("/register", validate(registerSchema), register);
r.post("/login", validate(loginSchema), login);
r.get("/me", auth, me);

// (Opcional) Endpoints de usuario
r.get("/users", auth, listUsers);
r.get("/users/:id", validate(userIdParamSchema), auth, getUser);
r.put("/users/:id", validate(userUpdateSchema), auth, updateUser);

export default r;
