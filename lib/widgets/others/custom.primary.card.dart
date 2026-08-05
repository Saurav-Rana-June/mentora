import 'package:flutter/material.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

class CustomPrimaryCard extends StatefulWidget {
  final Widget? child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomPrimaryCard({
    super.key,
    this.child,
    this.borderRadius,
    this.padding,
  });

  @override
  State<CustomPrimaryCard> createState() => _CustomPrimaryCardState();
}

class _CustomPrimaryCardState extends State<CustomPrimaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s8.symmetric.vertical,
          ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            offset: const Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            offset: const Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
