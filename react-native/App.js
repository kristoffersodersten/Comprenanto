import React, { useState, useEffect } from 'react';
    import { View, Text, TextInput, Button, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
    import axios from 'axios';
    import Sound from 'react-native-sound';

    function App() {
      const [audio, setAudio] = useState('');
      const [transcription, setTranscription] = useState('');
      const [translation, setTranslation] = useState('');
      const [audioSrc, setAudioSrc] = useState(null);
      const [mode, setMode] = useState('landing');

      useEffect(() => {
        Sound.setCategory('Playback');
      }, []);

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
          setAudioSrc(response.data.audio);
        } catch (error) {
          console.error('Error during translation:', error);
        }
      };

      const playAudio = () => {
        if (audioSrc) {
          const sound = new Sound(audioSrc, null, (error) => {
            if (error) {
              console.log('failed to load the sound', error);
              return;
            }
            sound.play((success) => {
              if (success) {
                console.log('successfully finished playing');
              } else {
                console.log('playback failed due to audio decoding errors');
              }
            });
          });
        }
      };

      const handleClean = () => {
        setTranscription(transcription.replace(/\b(um|uh|like)\b/gi, ''));
      };

      const handleCopyToClipboard = () => {
        // Implement copy to clipboard functionality
      };

      const renderLanding = () => (
        <View style={styles.container}>
          <Text style={styles.title}>Comprenanto</Text>
          <TouchableOpacity style={styles.button} onPress={() => setMode('transcribe')}>
            <Text style={styles.buttonText}>Transcribe</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button} onPress={() => setMode('translate')}>
            <Text style={styles.buttonText}>Translate</Text>
          </TouchableOpacity>
        </View>
      );

      const renderTranscribe = () => (
        <View style={styles.container}>
          <TouchableOpacity style={styles.button} onPress={() => setMode('landing')}>
            <Text style={styles.buttonText}>Back</Text>
          </TouchableOpacity>
          <TextInput
            style={styles.input}
            placeholder="Enter audio file"
            onChangeText={(text) => setAudio(text)}
          />
          <TouchableOpacity style={styles.button} onPress={handleTranscribe}>
            <Text style={styles.buttonText}>Transcribe</Text>
          </TouchableOpacity>
          <ScrollView style={styles.scrollView}>
            <Text style={styles.text}>{transcription}</Text>
          </ScrollView>
          <TouchableOpacity style={styles.button} onPress={handleClean}>
            <Text style={styles.buttonText}>Clean</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button} onPress={handleCopyToClipboard}>
            <Text style={styles.buttonText}>Copy to Clipboard</Text>
          </TouchableOpacity>
        </View>
      );

      const renderTranslate = () => (
        <View style={styles.container}>
          <TouchableOpacity style={styles.button} onPress={() => setMode('landing')}>
            <Text style={styles.buttonText}>Back</Text>
          </TouchableOpacity>
          <TextInput
            style={styles.input}
            placeholder="Enter audio file"
            onChangeText={(text) => setAudio(text)}
          />
          <TouchableOpacity style={styles.button} onPress={handleTranslate}>
            <Text style={styles.buttonText}>Translate</Text>
          </TouchableOpacity>
          <ScrollView style={styles.scrollView}>
            <Text style={styles.text}>{translation}</Text>
          </ScrollView>
          {audioSrc && <TouchableOpacity style={styles.button} onPress={playAudio}>
            <Text style={styles.buttonText}>Play Audio</Text>
          </TouchableOpacity>}
        </View>
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

      return <View style={styles.mainContainer}>{content}</View>;
    }

    const styles = StyleSheet.create({
      mainContainer: {
        flex: 1,
        backgroundColor: '#f0f0f0',
        alignItems: 'center',
        justifyContent: 'center',
      },
      container: {
        width: '80%',
        padding: 20,
        backgroundColor: '#fff',
        borderRadius: 8,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
      },
      title: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 20,
        textAlign: 'center',
      },
      button: {
        backgroundColor: '#007bff',
        padding: 10,
        borderRadius: 4,
        marginVertical: 5,
        alignItems: 'center',
      },
      buttonText: {
        color: 'white',
      },
      input: {
        borderWidth: 1,
        borderColor: '#ddd',
        borderRadius: 4,
        padding: 10,
        marginVertical: 10,
      },
      scrollView: {
        maxHeight: 150,
        marginVertical: 10,
      },
      text: {
        fontSize: 16,
      },
    });

    export default App;
