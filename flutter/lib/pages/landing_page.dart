import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/animated_logo.dart';
import '../core/services/haptic_service.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedLogo(size: 120),
              const SizedBox(height: 32),
              Text(
                'Comprenanto',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 48),
              _buildLandingButton(
                context,
                icon: CupertinoIcons.mic_fill,
                label: 'Transkribering',
                onTap: () {
                  HapticService.light();
                  Navigator.pushNamed(context, '/transcription');
                },
              ),
              const SizedBox(height: 16),
              _buildLandingButton(
                context,
                icon: CupertinoIcons.text_bubble_fill,
                label: 'Översättning',
                onTap: () {
                  HapticService.light();
                  Navigator.pushNamed(context, '/translation');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandingButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 