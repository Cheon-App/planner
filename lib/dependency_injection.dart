// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/services/app_info_service/app_info_service.dart';
import 'package:cheon/services/app_info_service/mock_app_info_service.dart';
import 'package:cheon/services/app_info_service/pi_app_info_service.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/services/key_value_service/hive_key_value_service.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/services/notification_service/local_notification_service.dart';
import 'package:cheon/services/notification_service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:kiwi/kiwi.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

final KiwiContainer container = KiwiContainer();

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// A configuration uses for automated tests that do not interact with real APIs
Future<void> registerTestDependencies() async {
  final AppInfoService mockAppInfoService = MockAppInfoService();

  container.registerInstance<AppInfoService>(mockAppInfoService);
}

Future<void> registerDependencies() async {
  Firebase.initializeApp();
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

  final NotificationService localNotificationService =
      LocalNotificationService();

  final String dbPath = path.join(dir.path, 'app.db');

  // ### ISOLATE ALTERNATIVE ###
  // final MoorIsolate moorIsolate = await _createMoorIsolate(dbPath);
  /// we can now create a database connection that will use the isolate
  /// internally. This is NOT what's returned from _backgroundConnection, moor
  /// uses an internal proxy class for isolate communication.
  // final DatabaseConnection connection =  await moorIsolate.connect()

  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }

  final DatabaseConnection connection = DatabaseConnection.fromExecutor(
      LazyDatabase(() => VmDatabase(File(dbPath))));

  final Database db = Database.connect(connection);

  container.registerInstance<AppInfoService>(
    packageInfoAppInfoService,
  );

  container.registerInstance<KeyValueService>(
    settingsKeyValueService,
  );

  container.registerInstance<KeyValueService>(
    timetableKeyValueService,
    name: 'timetable',
  );

  container.registerInstance<KeyValueService>(
    eventKeyValueService,
    name: 'event',
  );

  container.registerInstance<KeyValueService>(
    revisionKeyValueService,
    name: 'revision',
  );

  container.registerInstance<KeyValueService>(
    calendarKeyValueService,
    name: 'calendar',
  );

  container.registerInstance(db);

  final CalendarService deviceCalendarService = CalendarService();

  container.registerInstance<CalendarService>(deviceCalendarService);

  container.registerInstance<NotificationService>(localNotificationService);

  // container.registerInstance<CalendarVM>(CalendarVM());
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
