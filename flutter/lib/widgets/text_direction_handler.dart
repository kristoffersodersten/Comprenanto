import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/script_detector.dart';

class TextDirectionHandler extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool enableTTB;
  final VoidCallback? onTap;
  final bool selectable;

  const TextDirectionHandler({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.enableTTB = false,
    this.onTap,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = ScriptDetector.getTextDirection(text);
    final isVertical = enableTTB && ScriptDetector.isVerticalScript(text);

    Widget textWidget = selectable
        ? SelectableText(
            text,
            style: style ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: textAlign ?? (isVertical ? TextAlign.center : TextAlign.start),
            textDirection: textDirection,
            onTap: () {
              if (onTap != null) {
                HapticFeedback.selectionClick();
                onTap!();
              }
            },
          )
        : Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: textAlign ?? (isVertical ? TextAlign.center : TextAlign.start),
            textDirection: textDirection,
          );

    if (isVertical) {
      return RotatedBox(
        quarterTurns: textDirection == TextDirection.rtl ? -1 : 1,
        child: textWidget,
      );
    }

    return Directionality(
      textDirection: textDirection,
      child: textWidget,
    );
  }
} 