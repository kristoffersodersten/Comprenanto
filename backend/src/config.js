require('dotenv').config();

function validateConfig() {
  const requiredVars = ['ENCRYPTION_KEY', 'PORT', 'ALLOWED_ORIGINS'];
  const missing = requiredVars.filter(key => !process.env[key]);
  
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }
}

try {
  validateConfig();
} catch (error) {
  console.error('Configuration error:', error.message);
  process.exit(1);
}

const config = {
  port: process.env.PORT || 3001,
  encryptionKey: process.env.ENCRYPTION_KEY,
  allowedOrigins: (process.env.ALLOWED_ORIGINS || '').split(','),
  apiVersion: process.env.API_VERSION || '1.0',
  maxRequestSize: process.env.MAX_REQUEST_SIZE || '50mb'
};

module.exports = config; 