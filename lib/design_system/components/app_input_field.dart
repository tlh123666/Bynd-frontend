import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.controller,
    required this.label,
    this.hint,
    this.error,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.action,
    this.autofillHints,
    this.formatters,
    this.onChanged,
    this.onSubmitted,
    this.style,
    this.focusNode,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final String? hint, error;
  final bool enabled, autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? action;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChanged, onSubmitted;
  final TextStyle? style;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    focusNode: focusNode,
    autofocus: autofocus,
    enabled: enabled,
    keyboardType: keyboardType,
    textInputAction: action,
    autofillHints: autofillHints,
    inputFormatters: formatters,
    autocorrect: false,
    enableSuggestions: false,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    cursorColor: AppColors.textPrimary,
    style: style ?? AppTypography.detailBody,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
      errorMaxLines: 3,
      floatingLabelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.glass,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      border: _border(AppColors.glassBorderStrong),
      enabledBorder: _border(AppColors.glassBorderStrong),
      disabledBorder: _border(AppColors.glassBorder),
      focusedBorder: _border(AppColors.textSecondary),
      errorBorder: _border(AppColors.error),
      focusedErrorBorder: _border(AppColors.error),
    ),
  );
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color),
  );
}
