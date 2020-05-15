import 'package:cheon/services/app_info_service/app_info_service.dart';

/// Mock implementation of the [AppInfoService] class
class MockAppInfoService implements AppInfoService {
  @override
  String buildNumber() => '1';

  @override
  String versionName() => '1.0.0';
}
