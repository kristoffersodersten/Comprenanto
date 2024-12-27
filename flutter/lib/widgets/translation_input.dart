import 'package:flutter/material.dart';
import '../core/theme/spacing.dart';

class TranslationInput extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final bool isLoading;

  const TranslationInput({
    super.key,
    required this.text,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Spacing.medium),
      child: TextField(
        controller: TextEditingController(text: text)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          ),
        maxLines: 5,
        minLines: 3,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Enter text to translate',
          suffixIcon: isLoading
              ? Padding(
                  padding: EdgeInsets.all(Spacing.small),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : null,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
} 