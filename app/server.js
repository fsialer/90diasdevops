const { checkHealth } = require('./health');
const logger = require('./simple-logger');
const express = require('express');
const app = express();

app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`);
    next();
});

app.get('/ping', (req, res) => {
    logger.info('pong')
    res.json({
        status: "OK",
        timestamp: new Date(),
        message: "pong 🎉"
    })
})

app.get('/health', (req, res) => {
    const health = checkHealth();
    logger.info('Health check realizado');
    res.json(health);
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    logger.info(`Servidor iniciado en puerto ${PORT}`);
});