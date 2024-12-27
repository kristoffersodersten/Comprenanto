import 'package:flutter/material.dart';
// This import is causing an error
import '../widgets/feature_card.dart';
import '../widgets/gradient_background.dart';
import '../core/theme/spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Spacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Translator',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: Spacing.large),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: Spacing.medium,
                    crossAxisSpacing: Spacing.medium,
                    children: [
                      FeatureCard(
                        icon: Icons.mic,
                        title: 'Transcribe',
                        subtitle: 'Convert speech to text',
                        onTap: () => _navigateTo(context, '/transcribe'),
                      ),
                      FeatureCard(
                        icon: Icons.translate,
                        title: 'Translate',
                        subtitle: 'Translate your text',
                        onTap: () => _navigateTo(context, '/translate'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(context, '/settings'),
        child: const Icon(Icons.settings),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    // Assuming GoRouter is not available, replace with Navigator
    Navigator.of(context).pushNamed(route);
  }
} 