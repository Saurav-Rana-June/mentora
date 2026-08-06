import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final double? fontSize;
  final Color? textColor;

  const CustomAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.name,
    this.fontSize,
    this.textColor,
  });

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return "";
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      final first = parts[0];
      final second = parts[1];
      if (first.isNotEmpty && second.isNotEmpty) {
        return '${first[0]}${second[0]}'.toUpperCase();
      }
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final size = radius * 2;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl!.trim()),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final initials = _getInitials(name);
    final themePrimary = primary;
    final gradient = LinearGradient(
      colors: isDark
          ? [
              themePrimary,
              lightGreen,
            ]
          : [
              themePrimary.withValues(alpha: 0.9),
              darkGreen.withValues(alpha: 0.8),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: initials.isNotEmpty
            ? Text(
                initials,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: fontSize ?? (radius * 0.7).sp,
                  fontWeight: FontWeight.w700,
                  color: textColor ?? Colors.white,
                  letterSpacing: 1.0,
                ),
              )
            : Text(
                '\u{f007}',
                style: TextStyle(
                  fontFamily: 'FontAwesomeSolid',
                  fontSize: (radius * 0.9).sp,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
