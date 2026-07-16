---
name: performance
description: Rebuild scope, lists, pagination, debounce, and resource disposal for Flutter+GetX. Use for jank, large lists, or hot scroll/search paths.
---

# Performance & Async Discipline

## Overview

This skill captures performance practices for Flutter + GetX: controlling rebuilds, lazy registration, pagination, image and list efficiency, and async safety in controllers.

## Core Principles

* **Minimize rebuild scope**: Prefer local `StatefulWidget`/`Obx` islands over marking the whole tree dirty.
* **Lazy and fenix thoughtfully**: `lazyPut` defers construction; `fenix` revives disposed instances — use only when you understand lifetime.
* **Paginate remote lists**: Don’t load unbounded collections on first paint.
* **Dispose expensive resources**: Controllers, streams, `ScrollController`, `AnimationController`, and timers.

## Rules & Guidelines

### Do

* Use `ListView.builder` / `SliverList` for long lists, not unbounded `Column` of children.
* Debounce search inputs and expensive queries (300–500 ms typical).
* Cache stable network results in memory or on-disk when appropriate; invalidate on writes.
* Use `const` widgets and keys for list items when identity matters.

### Don't

* Don't `setState` on every scroll tick without throttling.
* Don't register permanent controllers for every feature.
* Don't hold large decoded images in memory without limits; use `cacheWidth`/`cacheHeight` where applicable.

## Patterns

### Pagination with guards

```dart
var _loadingMore = false;

Future<void> loadMore() async {
  if (_loadingMore || !_hasMore) return;
  _loadingMore = true;
  try {
    final next = await repo.fetch(page: page + 1);
    items.addAll(next);
    page++;
  } finally {
    _loadingMore = false;
  }
}
```

### Debounced search

```dart
Worker? _searchWorker;

@override
void onInit() {
  super.onInit();
  _searchWorker = debounce(
    searchQuery,
    (_) => runSearch(),
    time: const Duration(milliseconds: 400),
  );
}

@override
void onClose() {
  _searchWorker?.dispose();
  super.onClose();
}
```

### GetBuilder for granular updates

```dart
GetBuilder<FiltersController>(
  id: 'chips',
  builder: (_) => ChipFilters(),
);
```

## Code Examples

```dart
class CatalogController extends GetxController {
  final items = <Item>[].obs;
  final page = 0.obs;
  var _busy = false;

  Future<void> loadNextPage() async {
    if (_busy) return;
    _busy = true;
    try {
      final batch = await api.fetch(page: page.value + 1);
      if (batch.isEmpty) return;
      items.addAll(batch);
      page.value++;
    } finally {
      _busy = false;
    }
  }
}
```

## Anti-Patterns

* **`.obs` on giant objects** that change frequently, causing full subtree reactions.
* **Blocking UI isolate**: JSON parsing huge payloads on the UI thread without `compute` or isolates.
* **Leaked `StreamSubscription`** without cancel in `onClose`.

## Checklist

* [ ] Long lists use builders; keys assigned where needed.
* [ ] Search and scroll handlers debounced or guarded.
* [ ] Controllers dispose subscriptions and native resources.
* [ ] Images and assets sized appropriately for display.
* [ ] Network calls are not duplicated across rapid `onInit` / `onReady` without guards.

