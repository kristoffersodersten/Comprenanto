import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/transcription_notifier.dart';

class TranscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transcriptionNotifier = Provider.of<TranscriptionNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transcription Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transcription:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(transcriptionNotifier.transcriptionController.text),
            SizedBox(height: 16),
            Text(
              'Cleaned Up Transcription:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(transcriptionNotifier.cleanupText),
          ],
        ),
      ),
    );
  }
}
