import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package for HapticFeedback

// Create an enum for text style types if not exists
enum TextStyleType { bodyLarge, labelLarge }

class AdaptiveInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool isMultiline;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final String? languageCode;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AdaptiveInput({
    super.key,
    this.label,
    this.placeholder,
    this.value,
    this.onChanged,
    this.onTap,
    this.isMultiline = false,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textDirection,
    this.languageCode,
    this.controller,
    this.focusNode,
  });

  @override
  State<AdaptiveInput> createState() => _AdaptiveInputState();
}

class _AdaptiveInputState extends State<AdaptiveInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _focusController;
  late final Animation<double> _scaleAnimation;
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.value);

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      _focusController.forward();
      // Use HapticFeedback for tactile feedback
      HapticFeedback.lightImpact();
    } else {
      _focusController.reverse();
    }
  }

  TextStyle _getTextStyle(BuildContext context, TextStyleType type) {
    final theme = Theme.of(context);
    switch (type) {
      case TextStyleType.bodyLarge:
        return theme.textTheme.bodyLarge ?? const TextStyle();
      case TextStyleType.labelLarge:
        return theme.textTheme.labelLarge ?? const TextStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = _getTextStyle(
      context,
      TextStyleType.bodyLarge,
    );

    final surfaceColor = isDark
        ? Colors.grey[850] // Dark surface color
        : Colors.white; // Light surface color

    final borderColor = isDark
        ? Colors.grey[700] // Dark border color
        : Colors.grey[300]; // Light border color

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: _getTextStyle(
              context,
              TextStyleType.labelLarge,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12), // Medium radius
                border: Border.all(
                  color: _isFocused ? primaryColor : borderColor!,
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: [
                  if (_isFocused)
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: textStyle,
                maxLines: widget.isMultiline ? null : 1,
                keyboardType: widget.keyboardType ??
                    (widget.isMultiline ? TextInputType.multiline : TextInputType.text),
                textDirection: widget.textDirection,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: textStyle.copyWith(
                    color: isDark
                        ? Colors.grey[500] // Dark hint text
                        : Colors.grey[600], // Light hint text
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    _focusController.dispose();
    super.dispose();
  }
}