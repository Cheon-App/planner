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
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = false;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await runZonedGuarded<Future<void>>(() async {
    configureApp();

    FlavorConfig(flavor: Flavor.PRODUCTION);

    await registerDependencies();

    runApp(CheonApp());
  }, (Object error, StackTrace stackTrace) {
    Crashlytics.instance.recordError(error, stackTrace);
    /* if (const bool.fromEnvironment('dart.vm.product')) {
      try {
        sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
        print('Error sent to sentry.io: $error');
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
    } else {
      print(error);
    } */
  });
}
