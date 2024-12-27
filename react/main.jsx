import React, { useState, useRef } from 'react';
    import ReactDOM from 'react-dom';
    import axios from 'axios';

    function App() {
      const [audio, setAudio] = useState(null);
      const [transcription, setTranscription] = useState('');
      const [translation, setTranslation] = useState('');
      const [audioSrc, setAudioSrc] = useState('');
      const audioRef = useRef(null);

      const handleTranscribe = async () => {
        try {
          const response = await axios.post('http://localhost:3000/api/transcribe', { audio });
          setTranscription(response.data.transcription);
        } catch (error) {
          console.error('Error during transcription:', error);
        }
      };

      const handleTranslate = async () => {
        try {
          const response = await axios.post('http://localhost:3000/api/translate', { audio, targetLanguage: 'en' });
          setTranslation(response.data.translation);
          setAudioSrc(`data:audio/mpeg;base64,${response.data.audio}`);
          if (audioRef.current) {
            audioRef.current.load();
            audioRef.current.play();
          }
        } catch (error) {
          console.error('Error during translation:', error);
        }
      };

      return (
        <div>
          <input type="file" onChange={(e) => setAudio(e.target.files[0])} />
          <button onClick={handleTranscribe}>Transcribe</button>
          <p>Transcription: {transcription}</p>

          <button onClick={handleTranslate}>Translate</button>
          <p>Translation: {translation}</p>
          {audioSrc && <audio ref={audioRef} src={audioSrc} controls />}
        </div>
      );
    }

    ReactDOM.render(<App />, document.getElementById('root'));
