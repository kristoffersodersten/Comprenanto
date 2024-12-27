const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const bodyParser = require('body-parser');
const rateLimit = require('express-rate-limit');
const { decryptRequest, encryptResponse } = require('./middleware/security');
const config = require('./config');
const testRoutes = require('./routes/test-routes');

const app = express();

// Body parser
app.use(bodyParser.json({ limit: config.maxRequestSize }));
app.use(bodyParser.urlencoded({ extended: true }));

// Säkerhetsinställningar
app.use(helmet({
  contentSecurityPolicy: false, // Tillåt för utveckling
  crossOriginEmbedderPolicy: false // Tillåt för utveckling
}));

// CORS-konfiguration
app.use(cors({
  origin: '*',
  methods: ['POST'],
  allowedHeaders: ['Content-Type', 'X-Api-Version', 'X-Initialization-Vector'],
  exposedHeaders: ['Content-Type', 'X-Api-Version']
}));

// Rate limiting
app.use(rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
}));

// Debug middleware
app.use((req, res, next) => {
  console.log('Request Headers:', req.headers);
  console.log('Request Body:', req.body);
  next();
});

// Routes
app.use('/v1', testRoutes);

// Error handling
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Server error',
    message: err.message
  });
});

module.exports = app; 