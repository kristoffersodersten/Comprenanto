const crypto = require('crypto');
const config = require('../config');

function validateEncryptionKey(key) {
  try {
    const buffer = Buffer.from(key, 'base64');
    if (buffer.length !== 32) {
      throw new Error('Invalid key length');
    }
    return true;
  } catch (error) {
    return false;
  }
}

// Validera krypteringsnyckeln vid start
if (!validateEncryptionKey(config.encryptionKey)) {
  throw new Error('Invalid encryption key: Must be 32 bytes in base64 format');
}

const decryptRequest = (req, res, next) => {
  try {
    console.log('Decrypting request:', {
      headers: req.headers,
      body: req.body
    });

    // Skip decryption for non-encrypted requests during development
    if (process.env.NODE_ENV === 'development' && !req.headers['x-initialization-vector']) {
      console.log('Skipping decryption in development mode');
      return next();
    }

    if (!req.body || !req.body.data) {
      console.log('Missing encrypted data');
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Missing encrypted data',
        receivedBody: req.body
      });
    }

    const { data } = req.body;
    const iv = req.headers['x-initialization-vector'];
    
    if (!iv) {
      console.log('Missing IV header');
      return res.status(400).json({
        error: 'Invalid request',
        message: 'Missing initialization vector',
        receivedHeaders: req.headers
      });
    }

    const decipher = crypto.createDecipheriv(
      'aes-256-cbc',
      Buffer.from(config.encryptionKey, 'base64'),
      Buffer.from(iv, 'base64')
    );
    
    let decrypted = decipher.update(data, 'base64', 'utf8');
    decrypted += decipher.final('utf8');
    
    req.body = JSON.parse(decrypted);
    console.log('Decrypted body:', req.body);
    next();
  } catch (error) {
    console.error('Decryption error:', error);
    res.status(400).json({
      error: 'Decryption failed',
      message: error.message,
      stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};

const encryptResponse = (req, res, next) => {
  const originalSend = res.send;
  
  res.send = function (body) {
    try {
      console.log('Encrypting response:', body);

      // Skip encryption for non-encrypted requests during development
      if (process.env.NODE_ENV === 'development' && !req.headers['x-initialization-vector']) {
        console.log('Skipping encryption in development mode');
        return originalSend.call(this, body);
      }

      const iv = req.headers['x-initialization-vector'];
      if (!iv) {
        throw new Error('Missing initialization vector');
      }

      const cipher = crypto.createCipheriv(
        'aes-256-cbc',
        Buffer.from(config.encryptionKey, 'base64'),
        Buffer.from(iv, 'base64')
      );
      
      let encrypted = cipher.update(JSON.stringify(body), 'utf8', 'base64');
      encrypted += cipher.final('base64');
      
      console.log('Encrypted response:', encrypted);
      return originalSend.call(this, encrypted);
    } catch (error) {
      console.error('Encryption error:', error);
      return res.status(500).json({
        error: 'Encryption failed',
        message: error.message,
        stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
      });
    }
  };
  
  next();
};

module.exports = {
  decryptRequest,
  encryptResponse
}; 