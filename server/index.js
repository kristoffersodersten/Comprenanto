import express from 'express';
import { textToSpeech } from './tts.js';

const app = express();
const port = 3000;

const speakRouter = require('./routes/speak');
app.use('/speak', speakRouter);

app.get('/speak', async (req, res) => {
  const { text = 'Hello world!', lang = 'en', speed = 1 } = req.query;
  try {
    const ttsUrl = await textToSpeech(text, lang, parseFloat(speed));
    // In a real app, you might redirect or stream the audio, but here's a simple redirect example:
    res.redirect(ttsUrl);
  } catch (err) {
    res.status(500).send('Failed to generate TTS audio.');
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
}); 