---
name: dart-codegen
description: >-
  Dart code generation with build_runner—json_serializable, freezed, retrofit, and
  mockito. Use when adding DTOs, immutable models, API clients, or regenerating *.g.dart
  and *.freezed.dart files.
---

# Dart code generation

## Commands

- **One-shot build**: `dart run build_runner build --delete-conflicting-outputs`
- **Watch during development**: `dart run build_runner watch --delete-conflicting-outputs`
- Use **`--delete-conflicting-outputs`** when generated files drift or after git merges.

## json_serializable

- Annotate classes with **`@JsonSerializable()`**; run build_runner to emit **`*.g.dart`**.
- Prefer **`explicitToJson: true`** on nested models when API expects full object maps.
- Use **`@JsonKey(name: 'snake_case')`** when JSON keys differ from Dart fields.
- **Nullability** must match API reality—nullable fields for optional JSON keys.

## freezed (optional)

- Use **`@freezed`** for unions, copyWith, and equality when models are complex or branch on sealed states.
- Part files: **`part 'file.freezed.dart'`** and run build_runner.

## retrofit / API clients

- Keep **interface definitions** stable; regenerate clients after OpenAPI or backend contract changes.
- Do not hand-edit **`*.g.dart`** files—fix sources and re-run codegen.

## Mocks (mockito)

- **`@GenerateMocks([...])`** or build_runner with mockito’s codegen for large interfaces.
- Prefer **mocktail**’s `registerFallbackValue` when using typed `any()` in null-safe code.

## CI

- Commit generated files if the team policy requires reproducible builds without running codegen in CI—or run codegen in CI and fail on dirty git. **Match the repo’s existing policy.**

## Troubleshooting

- **Stale outputs**: clean with `dart run build_runner clean` then build again.
- **Conflicting outputs**: resolve duplicate `part` declarations or two generators writing the same path.
