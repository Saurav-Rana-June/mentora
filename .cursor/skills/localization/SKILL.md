---
name: localization
description: >-
  Flutter internationalization (l10n)—ARB files, gen-l10n, locale resolution, and
  formatting dates/numbers. Use when adding translations, RTL, or locale-aware UI.
---

# Localization (l10n)

## Project setup

- Prefer Flutter **`gen-l10n`** (`flutter gen-l10n`) with **`l10n.yaml`** at the project root and ARB files under `lib/l10n/` or `l10n/` (match existing project layout).
- Declare **`generate: true`** in `pubspec.yaml` under `flutter` when using code generation.
- Run **`flutter gen-l10n`** (or build) after editing ARB files so `AppLocalizations` stays in sync.

## ARB conventions

- Use **stable keys** (`loginButtonLabel`) not English sentences as keys.
- Keep **placeholders** explicit: `"itemCount": "{count, plural, ...}"` for plurals; document placeholder names in descriptions when needed.
- **Context** for translators: optional `description` fields in ARB for ambiguous strings.

## Code usage

- Access strings via the generated class (commonly **`AppLocalizations.of(context)!`** or the project’s extension)—**never** hardcode user-visible strings in widgets.
- Pass **`locale`** to `GetMaterialApp` / `MaterialApp` **`localizationsDelegates`** and **`supportedLocales`** from the same generated setup.

## Locale resolution

- Respect **`Localizations.localeOf(context)`**; allow user-selected locale to override device locale when the app stores a preference (e.g. GetX `Locale` or `SharedPreferences`).
- Test **RTL** (`Directionality`) for Arabic/Hebrew if those locales are supported.

## Formatting

- Use **`intl`** package for **dates, numbers, and currencies** with the active locale—avoid manual string concatenation for formatted values.

## Accessibility

- Translated strings may **change length**; avoid fixed-width boxes that clip German or Finnish text. Prefer flexible layouts and ellipsis where appropriate.
