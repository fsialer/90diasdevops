const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Configuración de base de datos
const pool = new Pool({
  host: process.env.DB_HOST || 'postgres-service',
  database: process.env.DB_NAME || 'ecommerce_db',
  user: process.env.DB_USER || 'ecommerce_user',
  password: process.env.DB_PASSWORD || 'devops2024',
  port: 5432,
});

// Configuración de Redis
const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST || 'redis-service',
    port: 6379
  }
});
redisClient.connect().catch(console.error);

// Health checks
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/health/ready', async (req, res) => {
  try {
    await pool.query('SELECT NOW()');
    await redisClient.ping();
    res.json({ status: 'ready', services: { database: 'ok', cache: 'ok' } });
  } catch (error) {
    res.status(503).json({ status: 'not ready', error: error.message });
  }
});

// Inicializar base de datos
async function initDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS products (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        price DECIMAL(10,2) NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0
      )
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS orders (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        products JSONB NOT NULL,
        total DECIMAL(10,2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Insertar productos de ejemplo
    const productCount = await pool.query('SELECT COUNT(*) FROM products');
    if (parseInt(productCount.rows[0].count) === 0) {
      await pool.query(`
        INSERT INTO products (name, description, price, stock) VALUES
        ('Laptop DevOps', 'Laptop para DevOps Engineers', 1299.99, 10),
        ('Kubernetes Book', 'Guía completa de K8s', 49.99, 50),
        ('Docker T-Shirt', 'Camiseta oficial', 25.99, 100),
        ('AWS Course', 'Curso certificación AWS', 199.99, 25)
      `);
    }
  } catch (error) {
    console.error('Error inicializando BD:', error);
  }
}

// API endpoints
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products ORDER BY id');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/orders', async (req, res) => {
  try {
    const { userId, products, total } = req.body;
    const result = await pool.query(
      'INSERT INTO orders (user_id, products, total) VALUES ($1, $2, $3) RETURNING *',
      [userId, JSON.stringify(products), total]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/orders', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM orders ORDER BY created_at DESC');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
initDatabase().then(() => {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Backend corriendo en puerto ${PORT}`);
  });
});