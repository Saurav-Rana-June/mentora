import 'package:flutter/material.dart';
import 'package:my_icons/my_icons.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  final double size;
  final double borderRadius;
  final double borderWidth;

  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final Color? inactiveBackgroundColor;

  final Duration animationDuration;
  final Curve animationCurve;

  final EdgeInsets padding;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
    this.borderRadius = 6,
    this.borderWidth = 2,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.inactiveBackgroundColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOut,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: padding,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve,
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: value
                ? (activeColor ?? theme.colorScheme.primary)
                : (inactiveBackgroundColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color:
                  borderColor ??
                  (value
                      ? (activeColor ?? theme.colorScheme.primary)
                      : theme.dividerColor),
              width: borderWidth,
            ),
          ),
          child: AnimatedOpacity(
            opacity: value ? 1 : 0,
            duration: animationDuration,
            // child: Icon(
            //   Icons.check,
            //   size: size * 0.6,
            //   color: checkColor ?? Colors.white,
            // ),
            child: Center(
              child: Text(
                MyIcons.circleCheck,
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: 15,
                  color: checkColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
