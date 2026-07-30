import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomReasonCard extends StatefulWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomReasonCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CustomReasonCard> createState() => _CustomReasonCardState();
}

class _CustomReasonCardState extends State<CustomReasonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.07, // Scales down to 0.93 on tap
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Smooth transitions for colors and styling
    final Color textColor = widget.isSelected
        ? (isDark ? slate[900]! : slate[900]!)
        : (isDark ? white : slate[800]!);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.value,
            vertical: Spacing.s12.value,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? primary
                : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: widget.isSelected
                  ? primary
                  : (isDark ? slate[700]! : slate[200]!),
              width: widget.isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? primary.withValues(alpha: 0.25)
                    : const Color.fromRGBO(0, 0, 0, 0.04),
                offset: widget.isSelected ? const Offset(0, 6) : const Offset(0, 2),
                blurRadius: widget.isSelected ? 16 : 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.icon,
                      style: TextStyle(
                        fontSize: 26.sp,
                      ),
                    ),
                    Spacing.s8.h,
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: r12.copyWith(
                        color: textColor,
                        fontWeight: widget.isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isSelected)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark ? white : slate[900],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 10.sp,
                      color: isDark ? slate[900] : white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
