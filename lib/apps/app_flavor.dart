import 'package:flutter/services.dart';

enum AppFlavor {
  app,
  cms;

  String get appTitle {
    switch (this) {
      case AppFlavor.app:
        return 'Mentora';
      case AppFlavor.cms:
        return 'Mentora CMS';
    }
  }

  bool get isCms => this == AppFlavor.cms;
  bool get isApp => this == AppFlavor.app;

  static AppFlavor _current = _detectFlavor();

  static AppFlavor get current => _current;
  static set current(AppFlavor flavor) => _current = flavor;

  static AppFlavor fromString(String? value) {
    if (value == null || value.trim().isEmpty) return AppFlavor.app;
    return AppFlavor.values.firstWhere(
      (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => AppFlavor.app,
    );
  }

  static AppFlavor _detectFlavor() {
    const envFlavor = String.fromEnvironment('FLAVOR');
    if (envFlavor.isNotEmpty) {
      return AppFlavor.fromString(envFlavor);
    }
    if (appFlavor != null && appFlavor!.isNotEmpty) {
      return AppFlavor.fromString(appFlavor);
    }
    return AppFlavor.app;
  }
}
