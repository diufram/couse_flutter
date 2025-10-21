import { Router } from "express";
import * as Orders from "../controllers/order.controller";

const r = Router();

r.get("/",  Orders.listOrders);
r.get("/:id",  Orders.getOrder);
r.post("/", Orders.createOrder);

export default r;
