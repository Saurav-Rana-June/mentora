---
name: flutter-expert
description: >-
  Dart and Flutter platform expertise—widgets, layout, async, lifecycle, accessibility,
  and production habits. Use for Flutter/Dart idioms, debugging UI, performance basics,
  or when building screens and logic outside GetX/API specifics. Complements getx, api,
  and project-architecture skills.
---

# Flutter expert (Dart & framework)

## Role

This skill is the **framework layer** playbook. For this repo, combine it with:

| Topic | Skill |
|-------|--------|
| GetX, DI, routes, controllers | `getx` |
| HTTP, Dio, interceptors | `api` |
| Session, tokens, 401 | `auth` |
| Repositories, DTOs | `repository` |
| Folders, layers | `project-architecture` |
| Snackbars, controller try/finally | `error-handling` |
| Lists, rebuild scope | `performance` |
| Theme, colors | `theme` |
| Screens, loading/empty/error | `ui` |
| Translations, ARB, RTL | `localization` |
| Unit/widget/integration tests | `flutter-testing` |
| build_runner, json_serializable, freezed | `dart-codegen` |

## Dart essentials

- Prefer **sound null safety**: model API fields as nullable when the backend can omit them; avoid `!` unless invariant is obvious.
- Use **`async`/`await`** in controllers/services; do not block the UI isolate with heavy CPU work—move to **`compute()`** or an isolate for large JSON/image work.
- **`Future` error paths**: use `try/catch` around awaited work; for streams, handle `onError` and cancel subscriptions in `onClose`.
- **Immutability** for view models/state snapshots where practical; avoid mutating shared lists/maps from multiple call sites without a clear owner.

## Widgets & layout

- **Build methods stay pure**: no side effects, no `async` in `build`, no navigation triggered from `build`.
- Prefer **`const` constructors** where possible to reduce rebuild work.
- **`LayoutBuilder` / constraints**: understand min/max width height; avoid infinite height in scrollables (unbounded `Column` inside `ListView` without sizing).
- **Scrollables**: one primary scroll per axis unless using `NestedScrollView` or explicit slivers; watch `shrinkWrap: true` cost on long lists.
- **Overlay layers**: `Overlay`, `ModalRoute`, dialogs—ensure dismissal and focus behavior match UX; pop with result types when the caller needs data.

## Keys, state, and lists

- Use **`Key`s** when widget identity must survive reorder (lists), or when preserving `State` across moves.
- **`ListView.builder`** / **`SliverList`** for long lists; avoid building thousands of children eagerly.
- **Stateful vs stateless**: push state down; lift state only as high as needed for sharing.

## Lifecycle & resources

- **Controllers** (`GetxController`): init heavy work in `onReady` when dependencies exist; dispose `TextEditingController`, `ScrollController`, `AnimationController`, timers, and stream subscriptions in **`onClose`**.
- **Widgets with `StatefulWidget`**: `dispose` must cancel listeners tied to that `State`.

## Accessibility & platform

- Set **`Semantics`** / **`semanticsLabel`** for icon-only controls; respect **`MediaQuery.textScaler`** (dynamic type).
- Touch targets: aim for at least ~48 logical pixels for primary actions.
- **Platform differences**: `Theme.of(context).platform`, `SafeArea`, notch/insets; test on both Android and iOS when behavior differs.

## Debugging & quality

- Use **Flutter DevTools** (widget inspector, performance overlay) for jank and layout issues.
- **`debugPrint`** / structured logging in development; avoid noisy logs in production hot paths.
- Run **`flutter analyze`** and fix lints before merge; align with project `analysis_options.yaml`.

## When to drill into another skill

- Routing, bindings, `Obx` scope → **`getx`**
- Endpoint contracts, parsing → **`repository`** + **`api`**
- User-visible failures → **`error-handling`**
- Golden/widget tests → **`flutter-testing`**
