import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/sanitizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool autofocus;
  final TextAlign textAlign;
  final TextStyle? style;
  final InputBorder? border;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.style,
    this.border,
    this.onChanged,
    this.suffixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      autofocus: autofocus,
      textAlign: textAlign,
      style: style,
      onChanged: onChanged,
      inputFormatters: [
        SanitizingTextInputFormatter(),
        ...?inputFormatters,
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
