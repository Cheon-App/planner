// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/flavor_config.dart';

/// Runs the app in a release configuration
Future<void> main() async {
  // Pass all uncaught errors from the framework to Crashlytics.

  await runZonedGuarded<Future<void>>(
    () async {
      configureApp();
      FlavorConfig(flavor: Flavor.PRODUCTION);
      await registerDependencies();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(CheonApp());
    },
    (exception, stackTrace, {reason, information, printDetails}) =>
        FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      reason: reason,
      information: information,
      printDetails: printDetails,
    ),
  );
}
