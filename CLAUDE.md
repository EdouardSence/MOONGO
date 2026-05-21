# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run app
flutter run

# Analyze / lint
flutter analyze

# Run all tests
flutter test

# Run single test file
flutter test test/viewmodels/home_viewmodel_test.dart

# Update golden screenshots
flutter test --update-goldens

# Regenerate Stacked code (router, locator, mocks) — run after editing app/app.dart or test_helpers.dart
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

**Stacked MVVM** — every view has a paired viewmodel.

- `lib/app/app.dart` — single source of truth for routes, services, dialogs, bottom sheets. All `// @stacked-*` comment markers are code-gen anchors; never remove them.
- `lib/app/app.router.dart`, `app.locator.dart`, `app.bottomsheets.dart`, `app.dialogs.dart` — **generated files**, do not edit manually. Re-run build_runner after any change to `app.dart`.
- Services are `LazySingleton` and accessed via `locator<ServiceName>()`.
- Views extend `StackedView<ViewModel>`. All navigation calls go through `locator<NavigationService>()`.

**Services**
- `AuthenticationService` — thin wrapper around `FirebaseAuth`.
- `FirestoreService` — all Firestore reads/writes. Caches `creature_species` collection in memory (`_speciesCache`).
- `StreakService` — streak logic triggered on startup; resets at midnight.
- `ThemeService` — persists light/dark mode; notifies `MainApp` via `ChangeNotifier`.

**Firestore collections**: `users`, `tasks`, `creatures`, `creature_species`

**Game economy**: users earn "seeds" by completing tasks; seeds are spent in the shop to buy eggs (which yield random creatures) and food (which grants creature XP/evolution).

**Task types**: `single` (one-off), `recurring` (resets daily), `objective` (has sub-tasks). Recurring tasks reset via `FirestoreService.resetRecurringTasks()`, called from `StartupViewModel`.

**Creature species** are stored in Firestore (not hardcoded) and enriched onto `CreatureModel` at query time via `withSpeciesData()`. Species data is cached per `FirestoreService` instance to avoid redundant fetches.

**Navigation flow**: `StartupView` → checks Firebase auth state → `LoginView` or `OnboardingView` (new users) or `TabsView` (returning users). `TabsView` hosts 5 tabs via `persistent_bottom_nav_bar`.

## Theme

`AppThemeExtension` is a `ThemeExtension` added to both `lightTheme` and `darkTheme`. Access it anywhere with `Theme.of(context).appTheme`. Never hardcode colors — use `AppColors`, `AppThemeExtension`, or `AppDecorations` helpers from `lib/ui/common/app_theme.dart`.

Typography: Fraunces (display/headings), DM Sans (body), Playfair Display (accent). Always use `AppTypography.*` helpers, not raw `TextStyle`.

## Testing

Viewmodel tests mock services using `test/helpers/test_helpers.dart`. Add new service mocks there (annotated with `@GenerateMocks`) then re-run build_runner to regenerate `test_helpers.mocks.dart`.

Golden tests screenshot `HomeView` and store results under `test/golden/`. Run `--update-goldens` intentionally after visual changes.
