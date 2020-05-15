import 'package:cheon/services/app_info_service/app_info_service.dart';
import 'package:package_info/package_info.dart';
import 'package:meta/meta.dart';

class PackageInfoAppInfoService implements AppInfoService {
  PackageInfoAppInfoService({@required this.packageInfo});
  final PackageInfo packageInfo;

  @override
  String buildNumber() => packageInfo.buildNumber;

  @override
  String versionName() => packageInfo.version;
}
