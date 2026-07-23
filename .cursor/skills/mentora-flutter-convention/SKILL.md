---
name: mentora-flutter-convention
description: Architecture, clean code screen structure, theme conventions, and UI design patterns for the Mentora Flutter application.
---

# Mentora Flutter Development Conventions

This skill defines the architectural standards, screen decomposition patterns, state management guidelines, and design system rules used across the **Mentora** Flutter application.

---

## 1. Directory & File Structure Conventions

Every feature module in Mentora resides under `lib/presentation/` and adheres to a predictable structure:

```text
lib/
├── infrastructure/
│   └── theme/
│       └── theme.dart              # Global AppTheme, colors, spacing, and typography definitions
├── presentation/
│   ├── screens.dart                # Central barrel export file for all screens
│   └── <feature_name>/             # camelCase directory (e.g., home, explore, sleep, moodCheckin)
│       ├── <feature_name>.screen.dart         # UI Screen widget
│       └── controllers/
│           └── <feature_name>.controller.dart  # GetX controller for state & logic
└── widgets/
    ├── bottomsheets/
    ├── buttons/
    ├── fields/
    └── others/                     # Shared UI components (e.g., custom.primary.card.dart)
```

### Screen Export Rule
Whenever a new screen is created, export it in `lib/presentation/screens.dart`:
```dart
export 'package:Mentora/presentation/<feature_name>/<feature_name>.screen.dart';
```

---

## 2. Clean Code Screen Architecture

Mentora screens follow a strict modular pattern to maintain readability, separation of concerns, and clean declarative layout logic.

### Core Rules for Screens:
1. **Extend `GetView<TController>`**: All screen classes extend `GetView<XController>`.
2. **Controller Injection**: Initialize the controller inside the screen using GetX injection:
   ```dart
   @override
   final controller = Get.put(XController());
   ```
3. **Declarative `build` Method**: The top-level `build` method MUST remain lightweight and clean, returning a `Scaffold` wired up to helper methods:
   ```dart
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Theme.of(context).primaryColorLight,
       appBar: buildAppbar(context),
       body: buildBody(context),
     );
   }
   ```
4. **Sectional UI Decomposition**:
   - Break down every visual section into dedicated private helper methods named with the `build` prefix (e.g., `buildAppbar`, `buildBody`, `buildTopBanner`, `buildConnectSection`, `buildTodayPlanTimelineTile`).
   - Pass `BuildContext context` to helper methods that access `Theme.of(context)`.
5. **GetX Reactive State Management**:
   - Use `Obx(() => ...)` around reactive widgets bound to `Rx` properties in the controller (e.g., `controller.selectedTabIndex.value`).

---

## 3. Theme & Styling Conventions

Theme configuration is located in `lib/infrastructure/theme/theme.dart`.

### A. Dynamic Theme & Color Tokens
Always prefer using theme-aware context properties so the UI responds seamlessly to light/dark modes.

* **Background Colors**:
  * Scaffold background / Page light surface: `Theme.of(context).primaryColorLight`
  * Card surface background: `Theme.of(context).cardTheme.color`
* **Text Colors**:
  * Primary Body Text: `Theme.of(context).textTheme.bodyLarge!.color`
  * Medium Body Text: `Theme.of(context).textTheme.bodyMedium!.color`
  * Subtitle / Small Text: `Theme.of(context).textTheme.bodySmall!.color`
* **Global Color Palette**:
  * Primary Accent: `primary` (`0xFFA5C67C`)
  * Secondary Accent: `secondary` (`0xFFF8F9F2`)
  * Neutral Shades: `slate` map (`slate[500]`, `slate[600]`, `slate[800]`, `slate[900]`)
  * Status Colors: `successColor`, `dangerColor`, `warningColor`, `infoColor`

### B. Typography Design Tokens
All typography is standardized using `Satoshi` font primitives and scaled with `flutter_screenutil` `.sp`:

| Primitive | Size (`.sp`) | Default Weight | Typical Usage |
| :--- | :--- | :--- | :--- |
| `h1` | `32.sp` | `w600` | Main Headers / Hero titles |
| `h2` | `24.sp` | `w600` | Screen Titles / Appbar Title |
| `h3` | `22.sp` | `w600` | Section Titles |
| `r20` | `20.sp` | `w400` | Large Text |
| `r18` | `18.sp` | `w400` | Card Headers / Subheaders |
| `r16` | `16.sp` | `w400` | Body Text / Button Text |
| `r14` | `14.sp` | `w400` | Subtext / Captions |
| `r12` | `12.sp` | `w400` | Small Captions / Timestamps |
| `r10` | `10.sp` | `w400` | Micro Labels |

#### Typography Usage Pattern:
Modify weight and theme color via `.copyWith()`:
```dart
Text(
  "Screen Title",
  style: h2.copyWith(
    color: Theme.of(context).textTheme.bodyLarge!.color,
    fontWeight: FontWeight.w600,
  ),
)
```

### C. Spacing Tokens (`my_spacing`)
Avoid hardcoded `SizedBox` dimensions or manual `EdgeInsets` where spacing tokens are available.

* **Gap Extensions**:
  * Vertical Gap: `Spacing.s8.h`, `Spacing.s12.h`, `Spacing.s16.h`, `Spacing.s20.h`
  * Horizontal Gap: `Spacing.s8.w`, `Spacing.s12.w`, `Spacing.s16.w`, `Spacing.s24.w`
* **Padding Extensions**:
  * Horizontal Padding: `EdgeInsets.symmetric(horizontal: Spacing.s8.symmetric.horizontal)`
  * Vertical Padding: `EdgeInsets.symmetric(vertical: Spacing.s4.symmetric.horizontal)`

---

## 4. Reusable UI Components & Media Patterns

1. **`CustomPrimaryCard`**:
   - Use `CustomPrimaryCard(child: ...)` for standard card containers across screens. Automatically handles theme background and standard elevation/shadow.
2. **Icons**:
   - FontAwesome solid icons via Unicode escaped strings and custom font family:
     ```dart
     Text(
       '\u{f144}',
       style: TextStyle(fontFamily: 'FontAwesomeSolid', fontSize: 30, color: primary),
     )
     ```
   - Helper icons from `my_icons` package: `MyIcons.magnifyingGlass`, `MyIcons.heart`.
   - SVG icons via `flutter_svg`: `SvgPicture.asset("assets/moods/Happy Face.svg", width: 45, height: 45)`.
3. **Cached Remote Images**:
   - Use `CachedNetworkImage` with custom `placeholder` (showing `CircularProgressIndicator`) and `errorWidget` (`Icon(Icons.image_not_supported)`).
4. **Navigation**:
   - Named routes: `Get.toNamed(Routes.MOOD_CHECKIN)`
   - Direct screen pushing with transition:
     ```dart
     Get.to(
       () => FavoriteScreen(),
       transition: Transition.rightToLeft,
     );
     ```

---

## 5. Standard Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';

import 'controllers/feature.controller.dart';

class FeatureScreen extends GetView<FeatureController> {
  FeatureScreen({super.key});

  @override
  final controller = Get.put(FeatureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "Feature Title",
        style: h2.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      child: Column(
        children: [
          buildMainCard(context),
        ],
      ),
    );
  }

  Widget buildMainCard(BuildContext context) {
    return CustomPrimaryCard(
      child: Row(
        children: [
          Text(
            "Card Content",
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
