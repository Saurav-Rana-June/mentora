import 'package:flutter/material.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomBottomsheet extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final String? description;
  final TextStyle? descriptionStyle;
  final Widget? child;
  final Widget? footer;
  final bool showDragHandle;
  final Color? dragHandleColor;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomBottomsheet({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.description,
    this.descriptionStyle,
    this.child,
    this.footer,
    this.showDragHandle = true,
    this.dragHandleColor,
    this.backgroundColor,
    this.borderRadius = 40.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        padding: padding ?? const EdgeInsets.fromLTRB(20, 10, 20, 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDark ? slate[900] : Colors.white),
          borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
          border: isDark
              ? Border(
                  top: BorderSide(
                    color: slate[800]!,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            if (showDragHandle)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: dragHandleColor ?? (isDark ? slate[700] : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            // Title
            if (titleWidget != null)
              titleWidget!
            else if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: titleStyle ??
                      h3.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

            // Description
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: descriptionStyle ??
                      r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),

            // Custom Content Child
            if (child != null) child!,

            // Footer (Actions/Buttons)
            if (footer != null) ...[
              if (child != null || description != null) const SizedBox(height: 24),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
