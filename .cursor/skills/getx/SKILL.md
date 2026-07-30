---
name: getx
description: GetX DI, reactive state, Bindings, navigation, and controller lifecycle in Flutter. Use for GetxController, Obx, GetPage, Get.find, or route-scoped registration.
---

# GetX State Management

## Overview

This skill covers production-grade use of GetX for dependency injection, reactive state, navigation, and controller lifecycle in Flutter. It emphasizes predictable registration, minimal rebuild scope, and separation between global long-lived state and feature-scoped controllers.

## Core Principles

* **Register dependencies where they are used**: Route-level `Bindings` for feature controllers; `permanent: true` only for app-wide singletons (for example a global coordinator).
* **Prefer reactive primitives intentionally**: `Rx` / `.obs` for values that drive UI; avoid making everything observable.
* **Respect lifecycle**: Initialize work in `onInit` / `onReady`, dispose native resources in `onClose`.
* **Avoid hidden globals**: Do not `Get.put` the same type in many places; one registration strategy per type.

## Rules & Guidelines

### Do

* Use `GetPage` + `Bindings` + `Get.lazyPut` for screen-scoped controllers so instances are created when the route opens and can be discarded when the route is removed (depending on `SmartManagement` / `fenix` choices).
* Use `Get.find<T>()` in controllers/widgets that are guaranteed to run after the binding (or after explicit `Get.put`).
* Use `Obx` / `GetX` only around widgets that must react to specific `Rx` values; keep the child subtree small.
* Use `update(['id'])` with `GetBuilder` when you need imperative, batched UI refresh without making fields reactive.
* Dispose `TextEditingController`, `ScrollController`, `AnimationController`, and stream subscriptions in `onClose`.
* Use `Get.isRegistered<T>()` before `Get.find` when resolving optional services (for example after logout teardown).

### Don't

* Don't call `Get.put` inside `build` methods or inside frequently rebuilt widgets.
* Don't use `.obs` for large objects that change as a whole on every keystroke unless the UI truly needs it; consider splitting models or using `ever` / `debounce` for expensive reactions.
* Don't rely on `Get.context!` without null checks in async gaps; context can be invalid after navigation.
* Don't mix multiple state solutions (Provider + Riverpod + GetX) for the same feature without a documented boundary.

## Patterns

### Route binding (lazy feature controller)

Feature controllers are registered when the route is opened, keeping memory scoped to the feature.

```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureController>(() => FeatureController());
  }
}
```

### Global app coordinator (permanent)

Use for cross-cutting session state that must survive route changes, with clear API surface.

```dart
// In app bootstrap (main), once:
Get.put<AppCoordinator>(AppCoordinator(), permanent: true);
```

### Reactive UI with narrow scope

```dart
class CounterView extends GetView<CounterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('${controller.count.value}'));
  }
}
```

### Granular rebuild with GetBuilder

Use named IDs when a single controller drives multiple independent UI regions.

```dart
void refreshHeaderOnly() => update(['header']);
```

## Code Examples

```dart
class OrdersController extends GetxController {
  final RxList<Order> items = <Order>[].obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      items.assignAll(await orderRepository.fetch());
    } finally {
      loading.value = false;
    }
  }
}
```

## Anti-Patterns

* **Mega-controller**: One `GetxController` with hundreds of fields for unrelated screens. Split by feature or aggregate via facades.
* **Reactive spaghetti**: Chains of `ever`/`worker` without disposal; always `worker.dispose()` or scope workers to controller lifetime.
* **Navigation from data layer**: Services should not own routing; they return results or throw, controllers decide `Get.toNamed`.
* **Using `Get.put` in services**: Creates hidden coupling and duplicate instances.

## Checklist

* [ ] Feature controllers registered via `Bindings` on the route (or a single module entry point).
* [ ] `onClose` disposes controllers and cancels subscriptions.
* [ ] `Obx`/`GetX` subtrees are small and mapped to specific observables.
* [ ] Global singletons are minimal, documented, and registered once at startup.
* [ ] No `Get.put` in `build`; no reactive leaks across routes.

