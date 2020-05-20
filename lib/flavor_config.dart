import 'package:flutter/material.dart';

enum Flavor { PROFILE, DEV, STAGING, PRODUCTION, TESTING }

class FlavorConfig {
  /// Denotes the app flavor being used. This influences the API end points
  /// and in app banners.
  factory FlavorConfig({
    @required Flavor flavor,
    Color color,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: _flavorToString(flavor),
      color: color,
    );

    return _instance;
  }

  FlavorConfig._internal({
    @required this.flavor,
    @required this.name,
    @required this.color,
  });

  static String _flavorToString(Flavor flavor) {
    switch (flavor) {
      case Flavor.PROFILE:
        return 'PROFILE';
        break;
      case Flavor.DEV:
        return 'DEV';
        break;
      case Flavor.STAGING:
        return 'STAGING';
        break;
      case Flavor.PRODUCTION:
        return 'PRODUCTION';
        break;
      case Flavor.TESTING:
        return 'TESTING';
        break;
    }
    return '';
  }

  final Flavor flavor;
  final String name;
  final Color color;
  static FlavorConfig _instance;

  static FlavorConfig get instance => _instance;

  bool isProduction() => _instance.flavor == Flavor.PRODUCTION;
  bool isDevelopment() => _instance.flavor == Flavor.DEV;
  bool isStaging() => _instance.flavor == Flavor.STAGING;
  bool isProfile() => _instance.flavor == Flavor.PROFILE;
  bool isTesting() => _instance.flavor == Flavor.TESTING;
}
