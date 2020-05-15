import 'package:cheon/dependency_injection.dart';
import 'package:cheon/view_models/app_info_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  await registerTestDependencies();

  group('app_info_view_model.dart |', () {
    test('buildNumber() returns the correct build number', () {
      final AppInfo appInfo = AppInfo();
      expect(appInfo.buildNumber, equals('1'));
    });
    test('versionName() returns the correct version name', () {
      final AppInfo appInfo = AppInfo();
      expect(appInfo.buildNumber, equals('1'));
    });
  });
}
