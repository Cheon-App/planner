// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/flavor_config.dart';

/// Runs the app with the staging backend mode
Future<void> main() async {
  configureApp();

  FlavorConfig(color: Colors.teal, flavor: Flavor.TESTING);

  await registerDependencies();

  runApp(CheonApp());
}
