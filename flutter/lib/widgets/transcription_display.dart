import 'package:flutter/material.dart';
import '../core/theme/spacing.dart';

class TranscriptionDisplay extends StatelessWidget {
  final String text;
  final bool isLoading;
  final String? error;

  const TranscriptionDisplay({
    super.key,
    required this.text,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Spacing.medium),
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: error != null 
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (text.isEmpty && !isLoading && error == null)
            Center(
              child: Text(
                'Start speaking to begin transcription',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: Spacing.small),
                      child: Text(
                        error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          if (isLoading)
            Positioned(
              top: Spacing.small,
              right: Spacing.small,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 