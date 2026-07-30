---
name: flutter-testing
description: >-
  Unit, widget, and integration testing for Flutter—test layout, mocks, async tests,
  GetMaterialApp harness, and golden tests. Use when adding tests, fixing flaky tests,
  or testing controllers and widgets.
---

# Flutter testing

## Tooling

- **`flutter_test`** for unit and widget tests (included with Flutter SDK).
- **`integration_test`** for end-to-end tests on device/emulator.
- **Mocking**: `mocktail` or `mockito`; generate mocks with `build_runner` if using codegen.
- **Coverage**: `flutter test --coverage`.

## Unit tests

- Test **pure functions**, mappers, validators, and repository methods with **fake** or **mock** HTTP clients—do not hit real network in unit tests.
- **Async**: use `testWidgets` or `test` with `async` and `await`; avoid unawaited futures.
- **Exceptions**: expect `throwsA`, `expect(() => ..., throwsException)`.

## Widget tests

- Wrap material apps with **`GetMaterialApp`** (or the same root widget the app uses) so `Theme`, `Directionality`, and GetX behave like production.
- **`tester.pumpWidget(...)`** then **`pump`** / **`pumpAndSettle`** for animations and async frames.
- Find widgets by **`find.text`**, **`find.byType`**, **`find.byKey`**, **`find.byIcon`**.
- **Interactions**: `tap`, `enterText`, `drag`; then `pump` again.

## GetX in tests

- Prefer **explicit `Get.put`** for the controller under test in `setUp`, and **`Get.reset()`** in `tearDown` when tests register dependencies—avoid cross-test leakage.
- If routes/bindings are required, register the same bindings as production or a test double with a narrow interface.

## Integration tests

- Use **`integration_test`** package; drive the real app entrypoint with **`IntegrationTestWidgetsFlutterBinding.ensureInitialized()`**.
- Keep tests **deterministic**: fixed clock, fake backend or staging, no race on real network when possible.

## Golden tests

- Use **`matchesGoldenFile`** for stable, non-animated UI snapshots; mask flaky regions (animations, timestamps) or pump to a settled frame first.
- Update goldens with **`flutter test --update-goldens`** only when UI changes are intentional.

## Flakiness

- Avoid **`Future.delayed`** in tests; use **`tester.pump(Duration)`** or fake async.
- Replace **`Timer`** with injectable abstractions in tests when verifying debounce behavior.
