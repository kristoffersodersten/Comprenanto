import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/services/feedback_service.dart';
import 'enhanced_container.dart';

class EnhancedTextInput extends StatefulWidget {
  final String? initialText;
  final String? hintText;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool readOnly;
  final bool enableTTB;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool selectable;

  const EnhancedTextInput({
    super.key,
    this.initialText,
    this.hintText,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.readOnly = false,
    this.enableTTB = false,
    this.style,
    this.onChanged,
    this.onTap,
    this.selectable = true,
  });

  @override
  State<EnhancedTextInput> createState() => _EnhancedTextInputState();
}

class _EnhancedTextInputState extends State<EnhancedTextInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return EnhancedContainer(
      isLoading: widget.isLoading,
      hasError: widget.hasError,
      errorMessage: widget.errorMessage,
      onTap: widget.onTap,
      child: Column(
        children: [
          if (widget.enableTTB && widget.selectable)
            _buildToolbar(theme),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                widget.readOnly ? _controller.text : widget.hintText ?? '',
                style: widget.style ?? theme.textTheme.bodyLarge?.copyWith(
                  color: _controller.text.isEmpty ? 
                      theme.hintColor : 
                      theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.start,
                onTap: () {
                  widget.onTap?.call();
                  FeedbackService.light();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          onPressed: _copyText,
          tooltip: 'Kopiera text',
        ),
        if (!widget.readOnly)
          IconButton(
            icon: const Icon(Icons.clear_outlined),
            onPressed: _clearText,
            tooltip: 'Rensa text',
          ),
      ],
    );
  }

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(text: _controller.text));
    FeedbackService.success(message: 'Text kopierad');
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    FeedbackService.light();
  }
} 