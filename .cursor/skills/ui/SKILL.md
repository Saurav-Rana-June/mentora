---
name: ui
description: Flutter UI composition, reusable widgets, loading/empty/error states, gates. Use for screens, layouts, and presentation widgets.
---

# UI Composition & Reusable Widgets

## Overview

This skill covers structuring Flutter UI with feature screens, reusable building blocks, permission-aware rendering, loading states, and responsive layout — aligned with GetX but portable to other state management.

## Core Principles

* **Screens compose, widgets encapsulate**: Screens orchestrate; leaf widgets stay dumb and testable.
* **One loading truth per async action**: Pair `isLoading` (or `AsyncValue`) with explicit UI for loading, empty, error, and success.
* **Gate features declaratively**: Wrap restricted UI in small widgets (`PermissionGate`, `RoleGate`) instead of scattering `if` checks.
* **Responsive by design**: Mobile-first layouts; widen columns on desktop using breakpoints or `LayoutBuilder`.

## Rules & Guidelines

### Do

* Extract repeated form rows, section headers, and list tiles into `widgets/` with clear parameters.
* Use `const` constructors wherever possible to reduce rebuild work.
* Prefer theme-driven padding (`EdgeInsets.symmetric(horizontal: 16)`) over magic numbers repeated hundreds of times — or define spacing tokens.
* Dispose scroll controllers and text controllers owned by the screen or controller in `onClose`.

### Don't

* Don't embed business rules in `build` beyond simple presentation; compute in the controller or view model.
* Don't nest `Column` inside `Column` without `Expanded`/`Flexible` where unbounded height is possible.
* Don't use `Obx` at the root of a huge screen without splitting observables.

## Patterns

### Permission gate

```dart
class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    required this.allowed,
    required this.child,
    this.fallback,
  });

  final bool allowed;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (!allowed) return fallback ?? const SizedBox.shrink();
    return child;
  }
}
```

With reactive policy:

```dart
Obx(() {
  if (!session.can(Permission.editOrders)) return const SizedBox.shrink();
  return child;
});
```

### Loading overlay

```dart
await Get.showOverlay(
  asyncFunction: () async {
    await longRunningOperation();
  },
  opacity: 0.5,
  opacityColor: Colors.black,
  loadingWidget: const AppLoader(),
);
```

### List + infinite scroll

```dart
scrollController.addListener(() {
  if (!scrollController.hasClients) return;
  if (scrollController.position.atEdge) {
    final isTop = scrollController.position.pixels == 0;
    if (!isTop) loadMore();
  }
});
```

## Code Examples

```dart
class AsyncSection extends StatelessWidget {
  const AsyncSection({
    super.key,
    required this.loading,
    required this.error,
    required this.child,
  });

  final bool loading;
  final Object? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(child: Text('Something went wrong'));
    }
    return child;
  }
}
```

## Anti-Patterns

* **Mega build method**: Thousands of lines in one `build`; extract subviews.
* **Duplicate UI** across admin vs user flows with copy-paste; extract shared components.
* **Hidden side effects in `build`**: Calling `fetch()` from `build` causes loops.

## Checklist

* [ ] Loading / empty / error states are explicit for async lists.
* [ ] Restricted actions are gated in one place per feature.
* [ ] Large screens split into private `Widget` classes or methods.
* [ ] Scroll and text controllers disposed when the owner is disposed.
* [ ] Touch targets and contrast meet platform guidelines.

