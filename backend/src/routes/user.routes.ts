import { Router } from "express";
import * as Auth from "../controllers/user.controller";
const r = Router();

r.get("/",  Auth.listUsers);
r.get("/:id",  Auth.getUser);
r.put("/:id",  Auth.updateUser);

export default r;
