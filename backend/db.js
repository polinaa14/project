import pkg from "pg";
const { Client } = pkg;

const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: 5432
});

export async function connectDB() {
    try {
        await client.connect();
        console.log("Connected to PostgreSQL");

        await client.query(`
            CREATE TABLE IF NOT EXISTS birthdays (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100),
                date VARCHAR(20)
            );
        `);

    } catch (err) {
        console.error("DB connection error:", err);
        process.exit(1);
    }
}

export { client };