import 'package:flutter/services.dart';

class Sanitizer {
  /// Removes potentially dangerous characters like <, >, and basic HTML/script tags
  static String sanitizeString(String input) {
    if (input.isEmpty) return input;
    
    // Replace < and > to prevent any HTML/XML injection
    String sanitized = input.replaceAll('<', '').replaceAll('>', '');
    
    // Remove invisible control characters (except common whitespace like \n, \t)
    sanitized = sanitized.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
    
    return sanitized.trim();
  }
}

class SanitizingTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow safe characters, specifically blocking < and >
    final sanitizedText = newValue.text.replaceAll(RegExp(r'[<>]'), '');
    
    return TextEditingValue(
      text: sanitizedText,
      selection: newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset.clamp(0, sanitizedText.length),
        extentOffset: newValue.selection.extentOffset.clamp(0, sanitizedText.length),
      ),
    );
  }
}
