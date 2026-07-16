---
name: project-architecture
description: Layering and folder layout (presentation/data/infrastructure), dependency direction, and composition root. Use for new features or structural refactors.
---

# Flutter Project Architecture (Clean-Aligned)

## Overview

This skill describes a scalable Flutter layout: **presentation** (screens, controllers), **domain** (optional when complexity warrants), **data** (services/repositories, DTOs, API client), and **infrastructure** (routing, theme, environment, config). It aligns with Clean Architecture principles without over-engineering small apps.

## Core Principles

* **Dependency direction**: Presentation depends on abstractions (interfaces) or concrete data facades; data layer does not depend on widgets.
* **Feature-first or layer-first**: Choose one primary structure; this playbook uses **layer-first** with feature folders inside `presentation/`.
* **Composition root**: `main.dart` wires global services, theme, and initial route; feature modules stay self-contained.
* **Configuration is injectable**: Base URLs, API keys, and feature flags come from environment or config objects, not literals in features.

## Rules & Guidelines

### Do

* Place **navigation** (`GetPage`, route table, `Routes` constants) in `infrastructure/navigation/` or `app/router/`.
* Place **theme** in `infrastructure/theme/` or `app/theme/`.
* Place **DTOs** under `data/_models/` with `request/` and `response/` split when volume grows.
* Keep **cross-cutting** utilities (`AppMethods`, formatters) thin; avoid business rules in utils.
* Use a **barrel file** (`screens.dart`, `controllers.dart`) sparingly for exports; avoid circular imports.

### Don't

* Don't import `presentation` from `data`.
* Don't put API keys or secrets in source control; use `--dart-define` or secure CI injection.
* Don't create `helpers/` as a junk drawer without boundaries.

## Patterns

### Folder layout (example)

```text
lib/
  main.dart
  app/
    app.dart
  controller/          # global coordinators (optional)
  data/
    _models/
    _services/
    _managers/
    _utils/
  infrastructure/
    navigation/
    theme/
    environment/
  presentation/
    GLOBAL/
      home/
      settings/
    FEATURE_X/
      feature_x.screen.dart
      controllers/
      views/
  widgets/
    form_fields/
    loaders/
```

### Route registration

```dart
class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
```

### Clean dependency flow

```text
UI (Screen) → Controller → Repository / Service → ApiClient → HTTP
```

Domain entities (if introduced) sit between controller and repository for large apps.

## Code Examples

```dart
// main.dart — composition root
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AppSession(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      theme: AppTheme.light,
    );
  }
}
```

## Anti-Patterns

* **Circular imports** between `feature_a` and `feature_b`; extract shared code to `core/` or `shared/`.
* **God folder** `utils/` with business logic named `common.dart`.
* **Duplicated environment** reads scattered across services.

## PubMeme Team Standards

### Spacing System (Mandatory)

Always use the project spacing enum + extension APIs for spacing and paddings:

* Vertical/horizontal gaps: `Spacing.s4.h`, `Spacing.s16.w`
* Padding and margins: `EdgeInsets.symmetric(horizontal: Spacing.s8.value)`
* Prefer `Spacing` values over hardcoded numbers (`8`, `12`, `16`) in UI layout code.

Expected imports:

```dart
import 'package:pub_meme/data/enums/spacing.enum.dart';
import 'package:pub_meme/data/extensions/spacing.extension.dart';
```

### Icon Source (Mandatory)

Always use icons from:

* `lib/infrastructure/theme/icons.dart`

Do not add inline font-icon unicode literals directly in feature widgets when the icon already exists in `icons.dart`.

### Screen Structure and Coding Pattern

Follow a structured `GetView` pattern similar to the examples:

* Keep `build()` clean: return `Scaffold` and delegate major UI sections to dedicated methods.
* Split UI into small methods such as `buildAppBar()`, `buildBodySection()`, `buildListSection()`, `buildTile()`.
* Use reactive builders (`Obx`) only around the minimum subtrees that actually need reactivity.
* Keep imports grouped and explicit: data enums/extensions, theme, widgets, third-party libs, then local controller import.

Example style:

```dart
import 'package:pub_meme/data/enums/spacing.enum.dart';
import 'package:pub_meme/data/extensions/spacing.extension.dart';
import 'package:pub_meme/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBodySection(context));
  }

  SafeArea buildBodySection(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildAppBar(),
          Spacing.s4.h,
          buildContentSection(),
        ],
      ),
    );
  }
}
```

### Performance-First Widget Choices

We always prefer non-expensive widgets and composition patterns to keep the app optimized and fast:

* Avoid unnecessary rebuilds, deep nesting, and oversized widget trees.
* Prefer `const` widgets where possible.
* Scope `Obx`/reactive rebuild areas tightly.
* Use lightweight layout primitives and extract reusable sub-widgets for heavy sections.

## Checklist

* [ ] Clear separation: presentation / data / infrastructure.
* [ ] Routes and bindings centralized and discoverable.
* [ ] Data layer is UI-agnostic; no `BuildContext` in services.
* [ ] Shared widgets truly reusable; no feature-specific hacks inside `widgets/`.
* [ ] New features can be added without renaming unrelated modules.
* [ ] Spacing uses `Spacing` enum + extension APIs (no raw spacing numbers).
* [ ] Icons are sourced from `infrastructure/theme/icons.dart`.
* [ ] Screens follow extracted build-method structure and performance-first widget choices.

