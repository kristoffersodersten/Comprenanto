const app = require('./app');
const config = require('./config');
const debug = require('debug')('server');

async function startServer(port) {
  try {
    const server = app.listen(port, () => {
      console.log('=================================');
      console.log(`🚀 Server running on port ${port}`);
      console.log('Environment:', {
        port: config.port,
        allowedOrigins: config.allowedOrigins,
        apiVersion: config.apiVersion,
        hasEncryptionKey: !!config.encryptionKey,
        nodeEnv: process.env.NODE_ENV
      });
      console.log('=================================');
    });

    server.on('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        console.log(`⚠️  Port ${port} is busy, trying ${port + 1}...`);
        server.close();
        startServer(port + 1);
      } else {
        console.error('❌ Server error:', err);
        debug(err);
        process.exit(1);
      }
    });

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    debug(error);
    process.exit(1);
  }
}

process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught exception:', error);
  debug(error);
  process.exit(1);
});

process.on('unhandledRejection', (error) => {
  console.error('❌ Unhandled rejection:', error);
  debug(error);
  process.exit(1);
});

console.log('🔄 Starting server...');
startServer(config.port); 