const app = require('./app');
const config = require('./config');

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// API routes
app.post('/v1/translate', async (req, res) => {
  try {
    const { text, sourceLanguage, targetLanguage } = req.body;
    
    if (!text || !sourceLanguage || !targetLanguage) {
      return res.status(400).json({
        error: 'Missing required fields',
        message: 'Text, source language and target language are required'
      });
    }

    const result = {
      translatedText: `[${targetLanguage}] ${text}`,
      sourceLanguage,
      targetLanguage,
      timestamp: new Date().toISOString()
    };
    
    res.json(result);
  } catch (error) {
    console.error('Translation error:', error);
    res.status(500).json({
      error: 'Translation failed',
      message: error.message
    });
  }
});

const server = app.listen(config.port, () => {
  console.log(`Server running on port ${config.port}`);
  console.log('Environment:', {
    port: config.port,
    allowedOrigins: config.allowedOrigins,
    apiVersion: config.apiVersion,
    hasEncryptionKey: !!config.encryptionKey
  });
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  server.close(() => {
    process.exit(1);
  });
});

process.on('unhandledRejection', (error) => {
  console.error('Unhandled Rejection:', error);
  server.close(() => {
    process.exit(1);
  });
});
