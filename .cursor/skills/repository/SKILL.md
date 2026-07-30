---
name: repository
description: Repository pattern, typed API boundaries, parsing at the edge, no UI in data layer. Use when adding services/repositories or DTOs.
---

# Repository & Data Layer

## Overview

This skill defines how to abstract remote data access behind predictable, testable boundaries in Flutter. It generalizes the “service + API client” pattern: domain-facing APIs that delegate HTTP, parsing, and cross-cutting policies to shared infrastructure.

## Core Principles

* **Single HTTP gateway**: Centralize timeouts, headers, auth attachment, logging, and response classification in one client (or a small family of clients per backend).
* **Stable contracts**: Return typed models or envelope types (`ApiResponse<T>`), not raw `Map`/`dynamic`, at the boundary you expose to presentation.
* **Feature grouping**: Group endpoints by bounded context (orders, profile, catalog), not by HTTP verb.
* **Parsing at the edge**: JSON deserialization happens once, close to the wire; controllers receive models.

## Rules & Guidelines

### Do

* Expose `Future<T>` / `Stream<T>` methods with explicit request/response types.
* Keep environment-specific base URLs and flavor configuration out of repositories; inject `BaseUrlResolver` or read from a config object.
* Map pagination, sorting, and filters through a single query builder or helper to avoid duplicated `dio.options.queryParameters` logic.
* Return `null` or a typed `Failure` only by convention that the team documents; do not mix three different “empty” meanings without names.

### Don't

* Don't construct a new HTTP client per call with different interceptors unless required; prefer one configured instance.
* Don't let UI models leak JSON keys; use `json_serializable` / `freezed` / handwritten `fromJson` in data DTOs.
* Don't perform navigation or show snackbars inside repository methods.

## Patterns

### Envelope response

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  const ApiResponse({
    required this.success,
    required this.data,
    this.message,
    this.error,
  });
}
```

### Repository method shape

```dart
class CatalogRepository {
  CatalogRepository(this._client);

  final ApiClient _client;

  Future<ApiResponse<Paginated<Product>>?> search({
    required String query,
    int page = 0,
    int pageSize = 20,
  }) {
    return _client.request<ApiResponse<Paginated<Product>>?>(
      (dio) {
        dio.options.queryParameters['query'] = query;
        dio.options.queryParameters['page'] = page;
        dio.options.queryParameters['pageSize'] = pageSize;
        return dio.get('/api/products/search');
      },
      parser: (json) => ApiResponse<Paginated<Product>>.fromJson(
        json as Map<String, dynamic>,
        (data) => Paginated<Product>.fromJson(data as Map<String, dynamic>),
      ),
    );
  }
}
```

### Optional abstract repository (for testing)

```dart
abstract class UserRepository {
  Future<User> me();
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._client);
  final ApiClient _client;

  @override
  Future<User> me() async {
    final res = await _client.request<User>(
      (dio) => dio.get('/api/me'),
      parser: (json) => User.fromJson(json as Map<String, dynamic>),
    );
    if (res == null) throw StateError('Unexpected empty response');
    return res;
  }
}
```

## Code Examples

```dart
// Shared client used by all repositories
final class ApiClient {
  Future<T?> request<T>(
    Future<Response> Function(Dio dio) requestFn, {
    required T? Function(dynamic json)? parser,
  }) async {
    // configure dio, attach auth, handle status codes, then parse
    throw UnimplementedError();
  }
}

// Domain-facing API stays narrow
class OrderRepository {
  OrderRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse<OrderDetail>?> getOrder(String id) {
    return _client.request<ApiResponse<OrderDetail>?>(
      (dio) => dio.get('/api/orders/$id'),
      parser: (json) => ApiResponse<OrderDetail>.fromJson(
        json as Map<String, dynamic>,
        (d) => OrderDetail.fromJson(d as Map<String, dynamic>),
      ),
    );
  }
}
```

## Anti-Patterns

* **God service**: A single class with every endpoint in the app; split by domain.
* **Duplicated Dio setup**: Copy-paste timeouts and headers in each file.
* **Controller parsing JSON**: Presentation should not know field names from wire format.
* **Leaking `Response` from Dio** to UI layers.

## Checklist

* [ ] One primary API client (or one per backend) owns cross-cutting behavior.
* [ ] Repositories return typed results; errors are thrown or returned via a single agreed mechanism.
* [ ] Query parameter construction is centralized or reused.
* [ ] Repositories have no `BuildContext`, no routes, no snackbars.
* [ ] Unit tests can fake repositories via interfaces or mocked clients.

