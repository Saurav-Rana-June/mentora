import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  final double? width;
  final double? height;

  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? textColor;

  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? loadingWidget;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.disabledColor,
    this.textColor,
    this.textStyle,
    this.borderRadius = 12,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color effectiveBackgroundColor = isDisabled
        ? (disabledColor ?? (isDark ? slate[600]! : slate[200]!))
        : (backgroundColor ?? Theme.of(context).primaryColor);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: Material(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isDisabled ? null : onPressed,
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: isLoading
                ? (loadingWidget ??
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: Loader(strokeWidth: 2, color: Colors.white),
                      ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style:
                            textStyle ??
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor ?? Colors.white,
                            ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: 8),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
