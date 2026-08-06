import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T?>? validator;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;

  /// Border customization
  final Color? borderColor;
  final double borderWidth;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  const CustomDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.fillColor,
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

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      style: r14.copyWith(color: theme.textTheme.bodyLarge?.color),
      icon: suffixIcon ?? Icon(
        Icons.keyboard_arrow_down_rounded,
        color: theme.textTheme.bodyMedium?.color,
      ),
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
        contentPadding: contentPadding,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 45,
          minHeight: 32,
        ),

        /// Borders
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
