import 'package:flutter/material.dart';

class ScriptDetector {
  static final RegExp _rtlScripts = RegExp(r'[\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC]');
  static final RegExp _verticalScripts = RegExp(r'[\u3000-\u303F\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF\uF900-\uFAFF]');

  /// Detects if text contains RTL characters
  static TextDirection getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    
    // Check first non-whitespace character
    final firstChar = text.trim().isNotEmpty ? text.trim().characters.first : '';
    if (_rtlScripts.hasMatch(firstChar)) {
      return TextDirection.rtl;
    }
    
    // Count RTL vs LTR characters
    final rtlCount = _rtlScripts.allMatches(text).length;
    final totalLength = text.trim().length;
    
    return rtlCount > totalLength / 2 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }

  /// Detects if text is in a vertical script (e.g., Traditional Chinese, Japanese)
  static bool isVerticalScript(String text) {
    if (text.isEmpty) return false;
    
    final verticalCount = _verticalScripts.allMatches(text).length;
    final totalLength = text.trim().length;
    
    return verticalCount > totalLength / 2;
  }

  /// Gets the appropriate text alignment based on script
  static TextAlign getTextAlign(String text) {
    if (isVerticalScript(text)) {
      return TextAlign.center;
    }
    return getTextDirection(text) == TextDirection.rtl 
        ? TextAlign.right 
        : TextAlign.left;
  }
} 