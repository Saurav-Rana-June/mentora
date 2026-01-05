import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;

  /// 🔥 New border customization
  final Color? borderColor;
  final double borderWidth;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.fillColor,

    /// defaults = no border
    this.borderColor,
    this.borderWidth = 0,
    this.focusedBorderColor,
    this.errorBorderColor,
  });

  OutlineInputBorder _border(Color? color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: borderWidth == 0
          ? BorderSide.none
          : BorderSide(color: color ?? Colors.transparent, width: borderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      style: r14,
      readOnly: readOnly,
      focusNode: focusNode,
      initialValue: initialValue,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: r14.copyWith(
          color:
              theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8) ??
              Colors.grey,
        ),
        labelText: labelText,
        labelStyle: r18.copyWith(color: theme.textTheme.bodyLarge?.color),
        floatingLabelStyle: r16.copyWith(
          color: theme.textTheme.bodyLarge?.color,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: labelText != null,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 45,
          minHeight: 32,
        ),

        /// 🔥 Borders
        border: _border(borderColor),
        enabledBorder: _border(borderColor),
        focusedBorder: _border(focusedBorderColor ?? borderColor),
        disabledBorder: _border(borderColor),
        errorBorder: _border(errorBorderColor ?? dangerColor),
        focusedErrorBorder: _border(errorBorderColor ?? dangerColor),

        filled: true,
        fillColor:
            fillColor ??
            theme.inputDecorationTheme.fillColor ??
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
      ),
    );
  }
}
