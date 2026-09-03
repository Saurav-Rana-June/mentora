import 'package:flutter/material.dart';

class CustomPrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double? toolbarHeight;
  final Size? customPreferredSize;

  const CustomPrimaryAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation = 0,
    this.scrolledUnderElevation,
    this.backgroundColor,
    this.surfaceTintColor = Colors.transparent,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.toolbarHeight,
    this.customPreferredSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: title,
      leading: leading,
      actions: actions ?? const <Widget>[],
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor ?? theme.primaryColorLight,
      surfaceTintColor: surfaceTintColor,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
    );
  }

  @override
  Size get preferredSize =>
      customPreferredSize ??
      Size.fromHeight(
        (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0.0),
      );
}
