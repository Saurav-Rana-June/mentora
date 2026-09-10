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

  static AppFlavor fromString(String? value) {
    if (value == null || value.trim().isEmpty) return AppFlavor.app;
    return AppFlavor.values.firstWhere(
      (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => AppFlavor.app,
    );
  }
}
