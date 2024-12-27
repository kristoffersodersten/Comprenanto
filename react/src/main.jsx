import React, { useState, useRef } from 'react';
    import ReactDOM from 'react-dom/client';
    import axios from 'axios';

    function App() {
      const [audio, setAudio] = useState(null);
      const [transcription, setTranscription] = useState('');
      const [translation, setTranslation] = useState('');
      const [audioSrc, setAudioSrc] = useState('');
      const audioRef = useRef(null);
      const [mode, setMode] = useState('landing');

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

      const handleClean = () => {
        // Implement logic to remove filler words and repetitions
        setTranscription(transcription.replace(/\b(um|uh|like)\b/gi, ''));
      };

      const handleCopyToClipboard = () => {
        navigator.clipboard.writeText(transcription);
      };

      const renderLanding = () => (
        <div>
          <h1>Comprenanto</h1>
          <button onClick={() => setMode('transcribe')}>Transcribe</button>
          <button onClick={() => setMode('translate')}>Translate</button>
        </div>
      );

      const renderTranscribe = () => (
        <div>
          <button onClick={() => setMode('landing')}>Back</button>
          <input type="file" onChange={(e) => setAudio(e.target.files[0])} />
          <button onClick={handleTranscribe}>Transcribe</button>
          <textarea value={transcription} readOnly />
          <button onClick={handleClean}>Clean</button>
          <button onClick={handleCopyToClipboard}>Copy to Clipboard</button>
        </div>
      );

      const renderTranslate = () => (
        <div>
          <button onClick={() => setMode('landing')}>Back</button>
          <input type="file" onChange={(e) => setAudio(e.target.files[0])} />
          <button onClick={handleTranslate}>Translate</button>
          <textarea value={translation} readOnly />
          {audioSrc && <audio ref={audioRef} src={audioSrc} controls />}
        </div>
      );

      let content;
      switch (mode) {
        case 'landing':
          content = renderLanding();
          break;
        case 'transcribe':
          content = renderTranscribe();
          break;
        case 'translate':
          content = renderTranslate();
          break;
        default:
          content = renderLanding();
      }

      return <div className="container">{content}</div>;
    }

    ReactDOM.createRoot(document.getElementById('root')).render(<App />);
