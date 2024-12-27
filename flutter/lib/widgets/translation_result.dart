import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/spacing.dart';

class TranslationResult extends StatelessWidget {
  final String text;
  final String? error;
  final bool isLoading;

  const TranslationResult({
    super.key,
    required this.text,
    this.error,
    this.isLoading = false,
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
      ),
      child: Stack(
        children: [
          if (text.isEmpty && !isLoading && error == null)
            Center(
              child: Text(
                'Translation will appear here',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Column(
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
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (text.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _copyToClipboard(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                  ),
              ],
            ),
          if (isLoading)
            Center(
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

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
  }
} 