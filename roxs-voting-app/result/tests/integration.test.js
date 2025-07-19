const request = require('supertest');

const APP_HOST = 'http://result:3000';

const waitForApp = async () => {
  const maxAttempts = 30;
  for (let i = 0; i < maxAttempts; i++) {
    try {
      const res = await request(APP_HOST).get('/healthz');
      if (res.status === 200) return true;
    } catch (err) {
      // App might not be ready yet
    }
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  throw new Error("App did not become ready in time");
};

describe('Integration Tests for Result Service', () => {
  beforeAll(async () => {
    await waitForApp();
  });

  test('GET /healthz should return status ok', async () => {
    const res = await request(APP_HOST).get('/healthz');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'ok');
    expect(res.body).toHaveProperty('service', 'result-service');
  });

  test('GET /metrics should return Prometheus metrics', async () => {
    const res = await request(APP_HOST).get('/metrics');
    expect(res.status).toBe(200);
    expect(res.text).toContain('http_requests_total');
    expect(res.headers['content-type']).toMatch(/text\/plain/);
  });

  test('GET / should serve HTML', async () => {
    const res = await request(APP_HOST).get('/');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
  });
});