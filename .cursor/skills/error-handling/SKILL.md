---
name: error-handling
description: User-facing errors, logging, snackbars, and controller-level try/finally patterns. Use when surfacing failures or hardening async flows.
---

# Error Handling & User Feedback

## Overview

This skill defines how Flutter apps should surface failures: typed errors at boundaries, consistent logging, non-blocking user notifications (snackbars, dialogs), and safe fallbacks when data is missing.

## Core Principles

* **Classify errors**: Distinguish network, server validation, auth, parsing, and programming bugs; handle each differently.
* **One UX channel for transient failures**: Use a shared snackbar/toast/banner helper with severity (`success`, `error`, `warning`, `info`).
* **Log for diagnostics, message for humans**: Log stack traces internally; show concise, actionable text to users.
* **Never swallow exceptions silently** except in documented, bounded cases (for example optional analytics).

## Rules & Guidelines

### Do

* In repositories/services, throw or return a typed result; let controllers decide whether to show UI.
* Map HTTP errors to readable strings via `messageFromApiErrorBody` or equivalent.
* Use `try/finally` to clear loading flags so UI never sticks in loading state.
* For lists, show inline error or empty state instead of a blank screen.

### Don't

* Don't display raw exception `toString()` in production unless sanitized (often includes internal paths).
* Don't chain `.catchError` without resetting loading flags on all paths.
* Don't use `print` in production; use a logger with levels.

## Patterns

### Controller-level catch

```dart
Future<void> submit() async {
  submitting.value = true;
  try {
    await repository.save(payload);
    AppSnackbar.success('Saved');
  } catch (e) {
    AppSnackbar.error(e.toString());
  } finally {
    submitting.value = false;
  }
}
```

### Snackbar with severity

```dart
enum SnackSeverity { success, error, warning, info }

void showSnack(String title, String message, SnackSeverity severity) {
  final color = switch (severity) {
    SnackSeverity.success => Colors.green,
    SnackSeverity.error => Colors.red,
    SnackSeverity.warning => Colors.orange,
    SnackSeverity.info => Colors.blue,
  };
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Get.theme.cardColor,
    leftBarIndicatorColor: color,
      duration: const Duration(seconds: 3),
  );
}
```

### Global 401 policy

```dart
void onUnauthorized() {
  AppSnackbar.info('Session expired', 'Please sign in again.');
  session.logout();
}
```

## Code Examples

```dart
Future<void> safeRun(Future<void> Function() job) async {
  try {
    await job();
  } catch (e, st) {
    Logger().e('Operation failed', error: e, stackTrace: st);
    AppSnackbar.error('Could not complete action');
  }
}

// Never do this in production UI:
// AppSnackbar.error(Exception('$e').toString());
```

## Anti-Patterns

* **Duplicate snackbars** for the same error from both repository and controller.
* **Empty catch (`catch (_) {}`)** hiding data loss bugs.
* **Using dialogs for non-blocking validation** on every keystroke.

## Checklist

* [ ] Loading / error flags are cleared in `finally` or symmetric paths.
* [ ] User-facing strings are short and free of stack traces.
* [ ] Logs include correlation (request id, route name) when available.
* [ ] Critical failures have a recovery path (retry button, go back).
* [ ] Parsing errors are logged and surfaced as “Couldn’t load data” rather than crashing.

