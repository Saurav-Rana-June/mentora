import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized breakpoint-aware scaling engine for Flutter Web and Admin CMS.
abstract final class AppScale {
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  // ---------------------------------------------------------------------------
  // Breakpoint Gates
  // ---------------------------------------------------------------------------
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth <= 1024;
  static bool get isDesktop => screenWidth > 1024;

  // ---------------------------------------------------------------------------
  // Typography Scaling (Clamped & Continuous Interpolation)
  // ---------------------------------------------------------------------------
  static double font(double size) {
    if (isMobile) {
      final double scale = ScreenUtil().scaleText;
      final double t = (screenWidth - 320) / (600 - 320);
      final double adaptedScale = (0.90 + t * (0.96 - 0.90)).clamp(0.90, 0.96);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else if (isTablet) {
      final double scale = ScreenUtil().scaleText;
      final double t = (screenWidth - 600) / (1024 - 600);
      final double adaptedScale = (0.96 + t * (1.00 - 0.96)).clamp(0.96, 1.00);
      return ScreenUtil().setSp(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
    } else {
      // Desktop / Web scaling clamped between 1.0x and 1.12x
      return size * (screenWidth / 1440).clamp(1.0, 1.12);
    }
  }

  // Pre-configured text scale shortcuts
  static double displayLarge() => font(48);
  static double displayMedium() => font(32);
  static double headline() => font(24);
  static double title() => font(18);
  static double body() => font(14);
  static double caption() => font(12);

  // ---------------------------------------------------------------------------
  // Icon Scaling
  // ---------------------------------------------------------------------------
  static double icon(double size) {
    if (isMobile) {
      final double t = (screenWidth - 320) / (600 - 320);
      final double adaptedScale = (0.80 + t * (0.90 - 0.80)).clamp(0.78, 0.95);
      return size * adaptedScale;
    }
    if (isTablet) return size + 2;
    return size * (screenWidth / 1440).clamp(0.95, 1.08);
  }

  // ---------------------------------------------------------------------------
  // Dampened Dimensional Scaling (Width, Height, Radius)
  // ---------------------------------------------------------------------------
  static double w(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      final t = (screenWidth - 600) / (1024 - 600);
      adaptedScale = 0.85 + t * (1.0 - 0.85);
    } else {
      final t = (screenWidth - 320) / (600 - 320);
      adaptedScale = (0.65 + t * (0.85 - 0.65)).clamp(0.65, 0.90);
    }
    return ScreenUtil().setWidth(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double h(double size) {
    final double scale = ScreenUtil().scaleHeight;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale;
    } else if (isTablet) {
      final t = (screenWidth - 600) / (1024 - 600);
      adaptedScale = 0.80 + t * (0.95 - 0.80);
    } else {
      final t = (screenWidth - 320) / (600 - 320);
      adaptedScale = (0.60 + t * (0.80 - 0.60)).clamp(0.60, 0.85);
    }
    return ScreenUtil().setHeight(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  static double r(double size) {
    final double scale = ScreenUtil().scaleWidth;
    double adaptedScale;
    if (isDesktop) {
      adaptedScale = scale.clamp(0.9, 1.0);
    } else if (isTablet) {
      adaptedScale = 0.9;
    } else {
      adaptedScale = 0.8;
    }
    return ScreenUtil().radius(size * (adaptedScale / scale.clamp(0.001, double.infinity)));
  }

  // ---------------------------------------------------------------------------
  // Universal Layout Spacing & Max Bounds
  // ---------------------------------------------------------------------------
  static double pagePaddingHorizontal([BuildContext? context]) {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 24;
  }

  static double pagePaddingVertical([BuildContext? context]) {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 24;
  }

  static double sectionPaddingVertical([BuildContext? context]) {
    if (isMobile) return 24;
    if (isTablet) return 32;
    return 40;
  }

  static double heroPaddingVertical([BuildContext? context]) {
    if (isMobile) return 36;
    if (isTablet) return 48;
    return 60;
  }

  static double contentMaxWidth() {
    if (isMobile) return screenWidth;
    if (isTablet) return 920;
    return 1400;
  }

  static double dialogMaxWidth([dynamic a, dynamic b]) {
    double defaultMax = 580;
    if (a is num) {
      defaultMax = a.toDouble();
    } else if (b is num) {
      defaultMax = b.toDouble();
    }
    if (isMobile) return screenWidth - 32;
    return defaultMax;
  }
}
