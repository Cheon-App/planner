// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/flavor_config.dart';

/// Runs the app in a development configuration
Future<void> main() async {
  configureApp();

  FlavorConfig(color: Colors.blue, flavor: Flavor.DEV);

  await registerDependencies();

  runApp(CheonApp());
}
