import 'dart:async';

import 'package:cheon/app.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/flavor_config.dart';
import 'package:flutter/material.dart';

/// Runs the app in a development configuration
Future<void> main() async {
  configureApp();

  FlavorConfig(color: Colors.blue, flavor: Flavor.DEV);

  await registerDependencies();

  runApp(App());
}
