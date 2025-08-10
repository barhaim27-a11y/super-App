const express = require("express");
const mysql = require("mysql2/promise");

const app = express();

const {
  DB_HOST = "db",
  DB_PORT = "3306",
  DB_NAME = "super_app",
  DB_USER = "root",
  DB_PASSWORD = "password",
  PORT = 3000,
} = process.env;

async function dbPing() {
  const conn = await mysql.createConnection({
    host: DB_HOST,
    port: Number(DB_PORT),
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
  });
  const [rows] = await conn.query("SELECT NOW() AS now");
  await conn.end();
  return rows[0].now;
}

app.get("/", (_req, res) => {
  res.send("Node service is up ✅ — go to /health or /db");
});

app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.get("/db", async (_req, res) => {
  try {
    const now = await dbPing();
    res.json({ db: "ok", now });
  } catch (e) {
    res.status(500).json({ db: "error", error: String(e) });
  }
});

app.listen(Number(PORT), "0.0.0.0", () => {
  console.log(`Node service listening on ${PORT}`);
});
