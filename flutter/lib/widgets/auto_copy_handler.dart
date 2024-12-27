import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/services/haptic_service.dart';
import '../widgets/loading_indicators.dart';

class AutoCopyHandler extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback? onCopyComplete;
  final Duration debounceTime;

  const AutoCopyHandler({
    super.key,
    required this.text,
    this.enabled = true,
    this.onCopyComplete,
    this.debounceTime = const Duration(milliseconds: 500),
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    if (!enabled || text.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: text));
      HapticService.success();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: LoadingIndicators.buildSuccessIndicator(
              context: context,
              message: 'Text kopierad till urklipp',
              onDismiss: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      onCopyComplete?.call();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kunde inte kopiera text'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _debounceText(text),
      builder: (context, debouncedText, _) {
        if (debouncedText != text) {
          _copyToClipboard(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  ValueNotifier<String> _debounceText(String text) {
    final notifier = ValueNotifier<String>('');
    
    Future.delayed(debounceTime, () {
      notifier.value = text;
    });
    
    return notifier;
  }
} 