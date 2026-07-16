---
name: theme
description: ThemeData, ColorScheme, typography tokens, light/dark. Use when styling screens or central theme modules.
---

# Theming, Color, and Typography

## Overview

This skill defines how to structure `ThemeData`, semantic color roles, typography scales, and light/dark support in Flutter so UI stays consistent and accessible across screens.

## Core Principles

* **Semantic colors first**: Define `primary`, `surface`, `error`, `onPrimary`, and use them in components instead of hardcoded hex in widgets.
* **Typography as a scale**: Map `TextTheme` roles (`titleLarge`, `bodyMedium`, …) to design tokens; avoid one-off font sizes in deep widget trees.
* **ThemeData is law**: Buttons, inputs, app bars, and cards should inherit defaults from `Theme.of(context)`; override locally only for exceptional cases.
* **Dark mode parity**: If you ship dark theme, every semantic token has a dark counterpart; do not only invert brightness ad hoc.

## Rules & Guidelines

### Do

* Expose palette steps as `Map<int, Color>` or const `Color` tokens, then bind `ColorScheme` to those tokens.
* Use `GoogleFonts` (or bundled fonts) inside `ThemeData` or a dedicated `AppTypography` class, not scattered `TextStyle` literals.
* Set `inputDecorationTheme`, `elevatedButtonTheme`, and `cardTheme` once to align forms and actions.
* Use `Theme.of(context).colorScheme` / `textTheme` in widgets; for GetX-only contexts without `BuildContext`, pass resolved colors/styles from the widget layer.

### Don't

* Don't sprinkle `Color(0xFF...)` in feature files.
* Don't rely on `Get.isDarkMode` unless `darkTheme` is actually wired; `darkTheme: lightTheme` defeats dark mode.
* Don't mix multiple display font families without hierarchy rules.

## Patterns

### Central typography tokens

```dart
class AppTypography {
  static final TextStyle title = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 24 / 18,
  );
}
```

### Line height from design specs

```dart
double lineHeightMultiplier({required double fontSize, required double lineHeight}) {
  return lineHeight / fontSize;
}
```

### Theme wiring

```dart
ThemeData buildLightTheme() {
  final scheme = ColorScheme.light(
    primary: primary,
    surface: surface,
    onSurface: onSurface,
  );
  return ThemeData(
    colorScheme: scheme,
    textTheme: TextTheme(
      titleLarge: AppTypography.title.copyWith(color: scheme.onSurface),
    ),
    useMaterial3: true,
  );
}
```

## Code Examples

```dart
class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF05CFD3)),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
  );
}

// In widgets — prefer theme over literals
Text('Hello', style: Theme.of(context).textTheme.titleLarge);
```

## Anti-Patterns

* **Duplicate text styles**: `TextStyle(fontSize: 14)` copied into dozens of files.
* **Primary color for errors**: Using brand color for validation errors; use `colorScheme.error`.
* **Opacity hacks**: `Colors.black.withOpacity(0.05)` everywhere instead of a dedicated divider/border token.

## Checklist

* [ ] `ThemeData` sets defaults for buttons, inputs, text, and cards.
* [ ] Screen widgets use `Theme.of(context)` / `DefaultTextStyle` patterns.
* [ ] Dark theme exists or `brightness` is explicitly single-theme by product decision.
* [ ] Status bar / system UI styles match scaffold background (`SystemChrome` set at app shell if needed).
* [ ] Accessibility: contrast checked for primary text on surfaces.

