// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:moor/isolate.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/services/app_info_service/app_info_service.dart';
import 'package:cheon/services/app_info_service/mock_app_info_service.dart';
import 'package:cheon/services/app_info_service/pi_app_info_service.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/services/calendar_service/device_calendar_service.dart';
import 'package:cheon/services/key_value_service/hive_key_value_service.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/services/notification_service/notification_service.dart';
import 'package:cheon/services/notification_service/local_notification_service.dart';

final kiwi.Container container = kiwi.Container();

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// A configuration uses for automated tests that do not interact with real APIs
Future<void> registerTestDependencies() async {
  final AppInfoService mockAppInfoService = MockAppInfoService();

  container
      .registerInstance<AppInfoService, MockAppInfoService>(mockAppInfoService);
}

Future<void> registerDependencies() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final AppInfoService packageInfoAppInfoService =
      PackageInfoAppInfoService(packageInfo: packageInfo);

  final Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  final Box<dynamic> settingsBox =
      await Hive.openBox<dynamic>('preferences_box');

  final Box<dynamic> timetableBox =
      await Hive.openBox<dynamic>('timetable_box');

  final Box<dynamic> eventBox = await Hive.openBox<dynamic>('event_box');
  final Box<dynamic> revisionBox = await Hive.openBox<dynamic>('revision_box');
  final Box<dynamic> calendarBox = await Hive.openBox<dynamic>('calendar_box');

  final KeyValueService settingsKeyValueService =
      HiveKeyValueService(settingsBox);

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

  final String dbPath = path.join(dir.path, 'app.db');

  // ### ISOLATE ALTERNATIVE ###
  // final MoorIsolate moorIsolate = await _createMoorIsolate(dbPath);
  /// we can now create a database connection that will use the isolate
  /// internally. This is NOT what's returned from _backgroundConnection, moor
  /// uses an internal proxy class for isolate communication.
  // final DatabaseConnection connection =  await moorIsolate.connect();

  final DatabaseConnection connection = DatabaseConnection.fromExecutor(
      LazyDatabase(() => VmDatabase(File(dbPath))));

  final Database db = Database.connect(connection);

  container.registerInstance<AppInfoService, PackageInfoAppInfoService>(
    packageInfoAppInfoService,
  );

  container.registerInstance<KeyValueService, HiveKeyValueService>(
    settingsKeyValueService,
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

  container.registerInstance(db);

  container.registerInstance<CalendarService, DeviceCalendarService>(
      deviceCalendarService);

  container.registerInstance<NotificationService, LocalNotificationService>(
      localNotificationService);
}

void unregisterDependencies() => container.clear();

Future<MoorIsolate> _createMoorIsolate(String path) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path),
  );

  // _startBackground will send the MoorIsolate to this ReceivePort
  return await receivePort.first as MoorIsolate;
}

void _startBackground(_IsolateStartRequest request) {
  // this is the entry point from the background isolate! Let's create
  // the database from the path we received
  final executor = VmDatabase(File(request.targetPath));
  // we're using MoorIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used MoorIsolate.spawn, a third isolate would be
  // started which is not what we want!
  final moorIsolate = MoorIsolate.inCurrent(
    () => DatabaseConnection.fromExecutor(executor),
  );
  // inform the starting isolate about this, so that it can call .connect()
  request.sendMoorIsolate.send(moorIsolate);
}

// used to bundle the SendPort and the target path, since isolate entry point
// functions can only take one parameter.
class _IsolateStartRequest {
  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);

  final SendPort sendMoorIsolate;
  final String targetPath;
}
