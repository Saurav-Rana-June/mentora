import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'apps/app_flavor.dart';
import 'apps/mentora_app.dart';
import 'apps/mentora_cms_app.dart';
import 'apps/mentora_doctor_app.dart';
import 'data/methods/app_method.dart';
import 'infrastructure/navigation/routes.dart';

/// Entry point supporting flavor injection via:
/// - Explicit [flavor] parameter (e.g., `main(flavor: AppFlavor.cms)`)
/// - Injected root [appWidget] (e.g., `main(appWidget: CustomApp())`)
/// - Compile-time `--dart-define=FLAVOR=cms` / `--dart-define=FLAVOR=doctor`
/// - Native Flutter [appFlavor]
void main({AppFlavor? flavor, Widget? appWidget}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Purge any stale, mock, or invalid tokens from local storage and ensure real token is set
  final existingToken = GetStorage().read<String>('user_token');
  final existingDocToken = GetStorage().read<String>('doctor_token');
  if (!AppMethod.isValidJwt(existingToken)) {
    await AppMethod.saveUserToken(AppMethod.defaultRealAuthToken);
    await AppMethod.saveUserEmail(AppMethod.defaultRealUserEmail);
  }
  if (!AppMethod.isValidJwt(existingDocToken)) {
    await GetStorage().remove('doctor_token');
  }

  final resolvedFlavor = flavor ?? _detectFlavor();
  AppFlavor.current = resolvedFlavor;
  final initialRoute = await Routes.initialRoute;

  final Widget app =
      appWidget ?? _buildAppForFlavor(resolvedFlavor, initialRoute);

  runApp(app);
}

AppFlavor _detectFlavor() {
  // 1. Check compile-time dart-define: --dart-define=FLAVOR=doctor / FLAVOR=cms / FLAVOR=app
  const envFlavor = String.fromEnvironment('FLAVOR');
  if (envFlavor.isNotEmpty) {
    return AppFlavor.fromString(envFlavor);
  }

  // 2. Check native appFlavor (e.g. android/ios build flavors)
  if (appFlavor != null && appFlavor!.isNotEmpty) {
    return AppFlavor.fromString(appFlavor);
  }

  // 3. Default fallback
  return AppFlavor.app;
}

Widget _buildAppForFlavor(AppFlavor flavor, String initialRoute) {
  switch (flavor) {
    case AppFlavor.cms:
      return MentoraCmsApp(initialRoute: initialRoute);
    case AppFlavor.doctor:
      return MentoraDoctorApp(initialRoute: Routes.LOGIN_DOCTOR);
    case AppFlavor.app:
      return MentoraApp(initialRoute: initialRoute);
  }
}

// Alias for backward compatibility
typedef Main = MentoraApp;
