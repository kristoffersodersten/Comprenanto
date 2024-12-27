const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const { decryptRequest, encryptResponse } = require('./middleware/security');
const config = require('./config');

const app = express();

// Säkerhetsinställningar
app.use(helmet());
app.use(express.json({ limit: config.maxRequestSize }));

// CORS-konfiguration
app.use(cors({
  origin: config.allowedOrigins,
  methods: ['POST'],
  allowedHeaders: ['Content-Type', 'X-Api-Version', 'X-Client-Id', 'X-Initialization-Vector']
}));

// Rate limiting
app.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minuter
  max: 100 // max 100 requests per windowMs
}));

// Kryptering/dekryptering av requests/responses
app.use(decryptRequest);
app.use(encryptResponse);

module.exports = app;
