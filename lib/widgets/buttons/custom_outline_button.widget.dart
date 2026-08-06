import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:Mentora/presentation/widgets/loaders/loader.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

class CustomOutlineButton extends StatelessWidget {
  final String label;
  final double? labelFontSize;
  final double? borderRadius;
  final double? borderSize;
  final Color? borderColor;
  final Color? textColor;
  final Widget? buttonIcon;
  final bool? isDisabled;
  final bool? isLoading;
  final bool? isInkWellDisabled;
  final double height;
  final Function() onTap;

  const CustomOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.labelFontSize,
    this.borderRadius,
    this.borderSize,
    this.borderColor,
    this.textColor,
    this.buttonIcon,
    this.isDisabled = false,
    this.isLoading = false,
    this.isInkWellDisabled = false,
    this.height = 45.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          border: Border.all(
            width: borderSize ?? 1.2,
            color: isDisabled!
                ? (borderColor ?? Theme.of(context).primaryColor).withValues(
                    alpha: 0.4,
                  )
                : (borderColor ?? Theme.of(context).primaryColor),
          ),
        ),
        child: InkWell(
          enableFeedback: !isInkWellDisabled!,
          splashFactory: isInkWellDisabled! ? NoSplash.splashFactory : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          onTap: isDisabled! ? null : onTap,
          child: Center(
            child: isLoading!
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: Loader(
                      color: borderColor ?? Theme.of(context).primaryColor,
                      strokeWidth: 2.3,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (buttonIcon != null)
                        Row(children: [buttonIcon!, Spacing.s8.w]),
                      Text(
                        label,
                        style: r16.copyWith(
                          color: isDisabled!
                              ? (textColor ?? Theme.of(context).primaryColor)
                                    .withValues(alpha: 0.5)
                              : (textColor ?? Theme.of(context).primaryColor),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
