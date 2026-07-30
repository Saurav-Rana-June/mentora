---
name: auth
description: Authentication, session, tokens, logout, and secure API headers. Use for login flows, session restore, or 401 coordination.
---

# Authentication & Session

## Overview

This skill describes secure, maintainable authentication flows in Flutter: credential login, token persistence, session restoration on cold start, authorized API calls, logout, and optional read-only or anonymous modes when product requirements allow.

## Core Principles

* **Single source of truth for session state**: A small coordinator (often a `GetxController` or service) exposes `isLoggedIn` and user profile; persistence and memory stay in sync.
* **Store tokens safely**: Prefer platform secure storage for refresh tokens; if using key-value stores, understand the threat model.
* **Validate session early**: On launch, if a token exists, call a lightweight “session check” (`/me` or token introspection) before showing protected UI.
* **Logout is total client-side**: Network logout is best-effort; always clear local tokens, caches, and in-memory permission state.

## Rules & Guidelines

### Do

* After successful login, normalize the user model and persist it in one pipeline (`adaptUser` + `loggedInCallback`).
* Clear **both** secure storage and in-memory singletons on logout (including permission caches and feature flags derived from identity).
* Centralize 401 handling to trigger logout or refresh, not per-screen duplication.
* If you support **guest / anonymous** access, represent it as an explicit session kind (for example `SessionMode.guest`) with constrained permissions, not “null user with full API access.”

### Don't

* Don't keep multiple unsynchronized copies of the access token in different singletons.
* Don't navigate from low-level HTTP code without a session coordinator; UI routing belongs in one layer.
* Don't call `reloadAll` or global resets without understanding impact on registered controllers.

## Patterns

### Session check on startup

```dart
Future<bool> restoreSession() async {
  final stored = secureStorage.readAccessToken();
  if (stored == null || stored.isEmpty) return false;
  session.applyAccessToken(stored);
  try {
    await authApi.me(); // validates token; refreshes user
    return true;
  } catch (_) {
    await session.clearLocal();
    return false;
  }
}
```

### Logout pipeline

```dart
Future<void> logout() async {
  try {
    await authApi.logout(); // optional server invalidation
  } catch (_) {
    // ignore — client must still log out locally
  } finally {
    permissionStore.clear();
    await session.clearLocal();
    appRouter.toLogin();
  }
}
```

### Authorized HTTP

```dart
dio.options.headers['Authorization'] = 'Bearer ${session.accessToken}';
// or a custom header scheme if your backend requires it — use one convention app-wide
```

## Code Examples

```dart
class SessionStore extends GetxController with CacheManager {
  final isLoggedIn = false.obs;

  Future<void> applyLogin(User user) async {
    isLoggedIn.value = true;
    await saveUser(user);
  }

  Future<void> clearLocal() async {
    isLoggedIn.value = false;
    await removeUser();
  }
}

// After any 401 from API layer
void onUnauthorized() {
  Get.find<SessionStore>().clearLocal();
  Get.offAllNamed('/login');
}
```

## Anti-Patterns

* **Silent token drift**: Updating token in one place but not refreshing `Dio` default headers for subsequent calls.
* **Optimistic “logged in” UI**: Showing protected screens before `/me` succeeds.
* **Permission cache after logout**: Reusing RBAC lists from the previous user.

## Checklist

* [ ] Login, refresh (if any), and logout paths are documented and symmetric.
* [ ] Tokens never logged in production builds.
* [ ] Cold start restores or rejects session deterministically.
* [ ] 401 triggers a single coordinated recovery path.
* [ ] Guest mode (if used) is explicit and enforced in API or UI gates.

