// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/services/app_info_service/app_info_service.dart';

/// Exposes the version name and build number of the installed app
class AppInfo extends ChangeNotifier {
  AppInfo() {
    final AppInfoService appInfoService = container<AppInfoService>();

    _versionName = appInfoService.versionName();
    _buildNumber = appInfoService.buildNumber();
    notifyListeners();
  }

  String _versionName;

  /// The 3 part version number of the app e.g. 1.2.3
  String get versionName => _versionName;

  String _buildNumber;

  /// The build number of the app e.g. 42
  String get buildNumber => _buildNumber;
}
