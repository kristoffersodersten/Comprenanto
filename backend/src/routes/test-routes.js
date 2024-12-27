const express = require('express');
const router = express.Router();

router.post('/test', (req, res) => {
  try {
    console.log('Request received:', req.body);
    const { message } = req.body;
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }
    res.json({ success: true, message: `Received: ${message}` });
  } catch (error) {
    console.error('Error in /test route:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.post('/api/secure/translate', (req, res) => {
  try {
    const { text } = req.body;
    
    // Här kan du implementera din översättningslogik
    // För nu använder vi samma spegling som tidigare
    const translatedText = text.split('').reverse().join('');
    
    res.json({
      success: true,
      translatedText: translatedText
    });
  } catch (error) {
    console.error('Translation error:', error);
    res.status(500).json({
      success: false,
      error: 'Translation failed'
    });
  }
});

module.exports = router; 