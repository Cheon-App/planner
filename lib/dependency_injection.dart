import 'dart:io';

import 'package:cheon/services/app_info_service/app_info_service.dart';
import 'package:cheon/services/app_info_service/mock_app_info_service.dart';
import 'package:cheon/services/app_info_service/pi_app_info_service.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/services/calendar_service/device_calendar_service.dart';
import 'package:cheon/services/key_value_service/hive_key_value_service.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/services/notification_service/notification_service.dart';
import 'package:cheon/services/notification_service/local_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:moor_ffi/moor_ffi.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:moor/moor.dart';

final kiwi.Container container = kiwi.Container();

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// A configuration uses for automated tests that do not interact with real APIs
Future<void> registerTestDependencies() async {
  final AppInfoService mockAppInfoService = MockAppInfoService();

  container
      .registerInstance<AppInfoService, MockAppInfoService>(mockAppInfoService);

  container
      .registerSingleton<QueryExecutor, VmDatabase>((_) => VmDatabase.memory());
}

Future<void> registerDependencies() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final AppInfoService packageInfoAppInfoService =
      PackageInfoAppInfoService(packageInfo: packageInfo);
  ;

  final Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  final Box<dynamic> preferencesBox =
      await Hive.openBox<dynamic>('preferences_box');

  final Box<dynamic> timetableBox =
      await Hive.openBox<dynamic>('timetable_box');

  final Box<dynamic> eventBox = await Hive.openBox<dynamic>('event_box');
  final Box<dynamic> revisionBox = await Hive.openBox<dynamic>('revision_box');
  final Box<dynamic> calendarBox = await Hive.openBox<dynamic>('calendar_box');

  final KeyValueService preferencesKeyValueService =
      HiveKeyValueService(preferencesBox);

  final KeyValueService timetableKeyValueService =
      HiveKeyValueService(timetableBox);

  final KeyValueService eventKeyValueService = HiveKeyValueService(eventBox);
  final KeyValueService revisionKeyValueService =
      HiveKeyValueService(revisionBox);

  final KeyValueService calendarKeyValueService =
      HiveKeyValueService(calendarBox);

  final CalendarService deviceCalendarService = DeviceCalendarService(
    keyValueService: calendarKeyValueService,
  );

  final NotificationService localNotificationService =
      LocalNotificationService();

  final LazyDatabase database = LazyDatabase(
    () async {
      final File file = File(path.join(dir.path, 'app.db'));
      return VmDatabase(
        file,
        logStatements: false, //FlavorConfig.instance.isDevelopment(),
      );
    },
  );

  container.registerInstance<AppInfoService, PackageInfoAppInfoService>(
    packageInfoAppInfoService,
  );

  container.registerInstance<KeyValueService, HiveKeyValueService>(
    preferencesKeyValueService,
  );

  container.registerInstance<KeyValueService, HiveKeyValueService>(
    timetableKeyValueService,
    name: 'timetable',
  );

  container.registerInstance<KeyValueService, HiveKeyValueService>(
    eventKeyValueService,
    name: 'event',
  );

  container.registerInstance<KeyValueService, HiveKeyValueService>(
    revisionKeyValueService,
    name: 'revision',
  );

  container.registerInstance<QueryExecutor, LazyDatabase>(database);

  container.registerInstance<CalendarService, DeviceCalendarService>(
      deviceCalendarService);

  container.registerInstance<NotificationService, LocalNotificationService>(
      localNotificationService);
}

void unregisterDependencies() => container.clear();
