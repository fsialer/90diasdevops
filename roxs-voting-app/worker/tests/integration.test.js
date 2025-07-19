const request = require('supertest');
const { Client } = require('pg');
const Redis = require('ioredis');

const WORKER_HOST = 'http://worker:3000';

const waitForHealth = async () => {
  const maxTries = 30;
  for (let i = 0; i < maxTries; i++) {
    try {
      const res = await request(WORKER_HOST).get('/healthz');
      if (res.status === 200 && res.body.status === 'ok') return true;
    } catch (_) {}
    await new Promise(r => setTimeout(r, 1000));
  }
  throw new Error("Worker didn't become healthy in time");
};

describe('Worker Integration Test', () => {
  let redis;
  let pg;

  beforeAll(async () => {
    await waitForHealth();

    redis = new Redis({ host: 'redis', port: 6379 });
    pg = new Client({
      host: 'db',
      user: 'postgres',
      password: 'postgres',
      database: 'votes',
    });
    await pg.connect();
  });

  afterAll(async () => {
    await redis.quit();
    await pg.end();
  });

  test('Metrics endpoint responds', async () => {
    const res = await request(WORKER_HOST).get('/metrics');
    expect(res.status).toBe(200);
    expect(res.text).toContain('process_cpu_user_seconds_total');
  });

  test('Vote pushed to Redis gets written to PostgreSQL', async () => {
    const voter_id = `test_${Date.now()}`;
    const vote = 'a';
    const payload = JSON.stringify({ voter_id, vote });

    await redis.rpush('votes', payload);

    let found = false;
    for (let i = 0; i < 20; i++) {
      const { rows } = await pg.query(`SELECT * FROM votes WHERE id = $1`, [voter_id]);
      if (rows.length > 0 && rows[0].vote === vote) {
        found = true;
        break;
      }
      await new Promise(r => setTimeout(r, 1000));
    }

    expect(found).toBe(true);
  });
});