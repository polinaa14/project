import express from "express";
import cors from "cors";
import { connectDB, client } from "./db.js";

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

app.post("/api/birthdays", async (req, res) => {
    try {
        const { name, date } = req.body;
        const result = await client.query(
            "INSERT INTO birthdays (name, date) VALUES ($1, $2) RETURNING *",
            [name, date]
        );
        res.json(result.rows[0]);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

app.get("/api/birthdays", async (req, res) => {
    try {
        const result = await client.query("SELECT * FROM birthdays");
        res.json(result.rows);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

app.listen(3000, () => console.log("API running on 3000"));