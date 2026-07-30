---
name: naming
description: Dart/GetX naming for files, types, routes, and JSON. Use when adding screens, controllers, repositories, or route constants.
---

# Naming Conventions

## Overview

Consistent naming reduces cognitive load and makes large Flutter codebases navigable. This skill standardizes file names, types, members, and routes for Dart and GetX projects.

## Core Principles

* **Match intent to type**: Suffixes like `Controller`, `Service`, `Repository`, `Binding`, `Screen`, `View` describe the primary role.
* **One concept, one name**: Avoid synonyms (`UserManager` vs `UserService`) for the same layer.
* **Files mirror types**: `snake_case.dart` for `PascalCase` primary type, Dart convention.

## Rules & Guidelines

### Files and folders

* **Screens**: `feature_name.screen.dart` or `feature_name_page.dart` — pick one pattern per project.
* **Controllers**: `feature.controller.dart` colocated under `controllers/` or `presentation/feature/`.
* **Bindings**: `feature.controller.binding.dart` or `feature_binding.dart` — consistent suffix `Binding`.
* **Services / repositories**: `feature.service.dart` or `feature_repository.dart` under `data/`.
* **Models**: `user_profile.model.dart` with class `UserProfile` (or `user_profile.dart` if using `freezed` / single export file).

### Dart identifiers

* **Classes / enums / typedefs**: `UpperCamelCase`.
* **Members / locals / parameters**: `lowerCamelCase`.
* **Private**: Leading underscore for private members and private top-level functions.
* **Constants**: `lowerCamelCase` for const values (for example `const maxRetries = 3`); reserve `SCREAMING_CAPS` for legacy interop or `enum` raw values if required.

### GetX-specific

* **Routes**: `static const HOME = '/home';` or `static const String home = '/home';` — be consistent with `ALL_CAPS` vs `lowerCamel` for route constants.
* **Rx fields**: `isLoading`, `items`, `selectedId` — avoid redundant `rx` prefix in the name; type `RxBool` already signals reactivity.
* **Bindings class**: `HomeBinding` or `HomeControllerBinding` — match the export barrel and imports.

### API and JSON

* **Dart field names** follow Dart style; use `@JsonKey(name: 'user_id')` for wire names.
* **Enums** serialized as stable strings: `enum Status { active, archived }` with consistent `json` mapping.

## Patterns

### Route constants

```dart
abstract class Routes {
  static const splash = '/splash';
  static const home = '/home';
}
```

### Controller + screen pairing

| File | Symbol |
|------|--------|
| `orders.screen.dart` | `OrdersScreen` |
| `orders.controller.dart` | `OrdersController` |

## Code Examples

```dart
// routes.dart
abstract class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
}

// order_repository.dart
class OrderRepository {
  Future<List<Order>> pending();
}

// order_detail_screen.dart
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});
  // ...
}
```

## Anti-Patterns

* **Hungarian notation everywhere**: `strName`, `iCount` in Dart.
* **Ambiguous `Utils`**: `Utils.doIt()` — prefer `DateFormatter.formatIsoDate`.
* **Mixing `Page` and `Screen` suffixes** for the same UI layer without distinction.

## Checklist

* [ ] Linter `file_names`, `camel_case_types`, `non_constant_identifier_names` pass.
* [ ] Route names and `GetPage.name` values match exactly.
* [ ] JSON field mapping uses annotations, not manual `map['snake_key']` in UI.
* [ ] Public API surface is readable without opening the file.

