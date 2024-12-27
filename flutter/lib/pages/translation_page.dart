import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/translation_notifier.dart';

class TranslationPage extends StatelessWidget {
  const TranslationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationNotifier = context.watch<TranslationNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Översättning'),
      ),
      body: Column(
        children: [
          if (translationNotifier.isTranslating)
            const LinearProgressIndicator(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: translationNotifier.sourceController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Skriv din text här...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: translationNotifier.translateText,
                  icon: const Icon(Icons.translate),
                  label: const Text('Översätt'),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: translationNotifier.targetController,
                    maxLines: null,
                    expands: true,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Din översättning visas här...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 