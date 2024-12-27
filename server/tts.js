import googleTTS from 'google-tts-api';

export async function textToSpeech(text, language = 'en', speed = 1) {
  try {
    // If speed !== 1, we pass `slow: true` for a slower voice
    const url = googleTTS.getAudioUrl(text, {
      lang: language,
      slow: speed !== 1,
      host: 'https://translate.google.com',
    });
    return url; // Return the TTS audio URL
  } catch (error) {
    console.error('Error generating TTS:', error);
    throw error;
  }
} 