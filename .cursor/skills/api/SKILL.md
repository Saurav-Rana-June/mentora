---
name: api
description: Dio/HTTP client policies: timeouts, status codes, 401 handling, error bodies, logging. Use when wiring or debugging API calls and interceptors.
---

# HTTP API Client & Resilience

## Overview

This skill standardizes how Flutter apps using Dio (or similar) handle status codes, error bodies, timeouts, logging, authentication headers, and consistent failure propagation to upper layers.

## Core Principles

* **Classify responses once**: A single policy function inspects HTTP status and business `success` flags before parsing.
* **401 is a session event**: Unauthorized responses trigger a controlled logout or refresh flow, not scattered handling in every screen.
* **Surface user-meaningful errors**: Parse `errorMessage` / `message` from structured JSON when present; fall back to status line, then generic text.
* **Fail fast with typed throws**: Prefer throwing `String` or domain exceptions at the client boundary only if the whole app agrees; otherwise use `Result`/`Either`.

## Rules & Guidelines

### Do

* Set `connectTimeout`, `receiveTimeout`, and `sendTimeout` explicitly for mobile networks.
* Log outgoing requests in debug builds (curl-style) with secrets redacted in production.
* On `DioException`, distinguish `error.response != null` (server spoke) from network/DNS/timeouts.
* Parse API error bodies defensively: `Map`, nested `message`, or JSON-in-`String`.

### Don't

* Don't ignore non-2xx bodies; they often contain the actionable message.
* Don't retry blindly on POST without idempotency keys.
* Don't show snackbars inside low-level HTTP code; signal upward and let presentation decide.

## Patterns

### Central response gate

```dart
bool processHttpResponse(Response response, {bool showErrorSnack = false}) {
  if (response.statusCode == 401) {
    sessionCoordinator.onUnauthorized();
    return false;
  }
  final ok = response.statusCode != null &&
      response.statusCode! >= 200 &&
      response.statusCode! <= 299;
  if (!ok && showErrorSnack) {
    uiBus.showError(resolveErrorMessage(response));
  }
  return ok;
}
```

### User-visible message extraction

```dart
String? messageFromBody(dynamic data) {
  if (data is Map) {
    final m = Map<String, dynamic>.from(data);
    final msg = m['errorMessage'] ?? m['message'];
    if (msg != null && msg.toString().trim().isNotEmpty) return msg.toString();
  }
  if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        final m = Map<String, dynamic>.from(decoded);
        final msg = m['errorMessage'] ?? m['message'];
        if (msg != null && msg.toString().trim().isNotEmpty) return msg.toString();
      }
    } catch (_) {}
  }
  return null;
}
```

### Request wrapper

```dart
Future<T?> execute<T>(
  Future<Response> Function(Dio dio) call, {
  required T? Function(dynamic json)? parse,
}) async {
  final dio = createConfiguredDio();
  try {
    final res = await call(dio);
    if (!processHttpResponse(res)) return null;
    return parse?.call(res.data);
  } on DioException catch (e) {
    if (e.response != null) {
      processHttpResponse(e.response!);
      throw resolveDioErrorMessage(e);
    }
    throw e.message ?? 'Network error';
  }
}
```

## Code Examples

```dart
class HttpFacade {
  HttpFacade(this._dio);
  final Dio _dio;

  Future<Response> get(String path) => _dio.get(path);
}

String resolveDioErrorMessage(DioException e) {
  final r = e.response;
  if (r == null) return e.message ?? 'Network error';
  final fromBody = messageFromBody(r.data);
  if (fromBody != null && fromBody.isNotEmpty) return fromBody;
  final sc = r.statusCode;
  final sm = r.statusMessage;
  return '${sc ?? ''}${sm != null && sm.isNotEmpty ? ' $sm' : ''}'.trim();
}
```

## Anti-Patterns

* **Stringly-typed everything**: `throw response.data` without normalizing types for callers.
* **Infinite retry on 401**: Refresh loops without attempt limits and backoff.
* **Mixing auth headers**: Some calls use `Authorization: Bearer`, others use custom headers, without documentation.

## Checklist

* [ ] Timeouts configured for all Dio instances used in production.
* [ ] Single place handles 401 and session teardown or token refresh.
* [ ] Error text prefers server-provided messages when available.
* [ ] Debug logging can be disabled or scrubbed for release builds.
* [ ] Callers know whether `null` means “failure already surfaced” vs “empty data”.

