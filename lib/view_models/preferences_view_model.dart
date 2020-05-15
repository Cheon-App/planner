import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar.dart';
import 'package:cheon/repositories/event_repository.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Preferences extends ChangeNotifier {
  Preferences() {
    _themeMode = ThemeMode.values[
        _keyValueService.getValue(THEME_MODE) ?? ThemeMode.system.index];

    _amoledDark = _keyValueService.getValue(AMOLED_DARK) ?? false;

    _homeworkReminders = _keyValueService.getValue(HOMEWORK_REMINDERS) ?? false;

    _homeworkReminderTime =
        _keyValueService.getValue(HOMEWORK_REMINDER_TIME) != null
            ? SerializedTimeOfDay.fromJson(
                _keyValueService.getValue(HOMEWORK_REMINDER_TIME),
              )
            : const TimeOfDay(hour: 16, minute: 00);

    _homeworkReminderDays = _keyValueService.getValue(HOMEWORK_REMINDER_DAYS) ??
        <bool>[for (int i = 0; i < 7; i++) false];

    _hideHolidayLessons =
        _keyValueService.getValue(HIDE_HOLIDAY_LESSONS) ?? false;

    _importCalendarEvents =
        _keyValueService.getValue(IMPORT_CALENDAR_EVENTS) ?? false;

    notifyListeners();
  }

  static const String THEME_MODE = 'theme_mode';
  static const String AMOLED_DARK = 'amoled_dark';
  static const String HOMEWORK_REMINDERS = 'homework_reminders';
  static const String HOMEWORK_REMINDER_TIME = 'homework_reminder_time';
  static const String HOMEWORK_REMINDER_DAYS = 'homework_reminder_days';
  static const String HIDE_HOLIDAY_LESSONS = 'hide_holiday_lessons';
  static const String IMPORT_CALENDAR_EVENTS = 'import_calendar_events';

  final KeyValueService _keyValueService = container<KeyValueService>();
  final EventRepository _eventRepository = EventRepository.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CalendarService _calendarService = container<CalendarService>();

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    notifyListeners();
    _keyValueService.setValue(THEME_MODE, _themeMode.index);
  }

  bool _amoledDark;
  bool get amoledDark => _amoledDark;
  set amoledDark(bool amoledDark) {
    if (_amoledDark == amoledDark) return;
    _amoledDark = amoledDark;
    notifyListeners();
    _keyValueService.setValue(AMOLED_DARK, _amoledDark);
  }

  bool _homeworkReminders;
  bool get homeworkReminders => _homeworkReminders;
  set homeworkReminders(bool enabled) {
    if (_homeworkReminders == enabled) return;
    _homeworkReminders = enabled;
    notifyListeners();

    _keyValueService.setValue(HOMEWORK_REMINDERS, _homeworkReminders);
    if (enabled) {
      _enableHomeworkNotifications();
    } else {
      _disableHomeworkNotifications();
    }
  }

  TimeOfDay _homeworkReminderTime;
  TimeOfDay get homeworkReminderTime => _homeworkReminderTime;
  set homeworkReminderTime(TimeOfDay time) {
    if (_homeworkReminderTime == time) return;
    _homeworkReminderTime = time;
    notifyListeners();
    _keyValueService.setValue(
      HOMEWORK_REMINDER_TIME,
      _homeworkReminderTime.toJson(),
    );
    _updateHomeworkNotifications();
  }

  List<bool> _homeworkReminderDays;
  List<bool> get homeworkReminderDays => _homeworkReminderDays;

  Future<void> toggleHomeworkReminderDay(int day) async {
    if (day == null) return;
    _homeworkReminderDays[day] = !_homeworkReminderDays[day];
    notifyListeners();
    await _keyValueService.setValue(
      HOMEWORK_REMINDER_DAYS,
      _homeworkReminderDays,
    );
  }

  bool _hideHolidayLessons;
  bool get hideHolidayLessons => _hideHolidayLessons;
  set hideHolidayLessons(bool hide) {
    if (_hideHolidayLessons == hide) return;
    _hideHolidayLessons = hide;
    notifyListeners();
    _keyValueService.setValue(HIDE_HOLIDAY_LESSONS, _hideHolidayLessons);
  }

  bool _importCalendarEvents;
  bool get importCalendarEvents => _importCalendarEvents;
  set importCalendarEvents(bool importCalendarEvents) {
    if (_importCalendarEvents == importCalendarEvents) return;
    _importCalendarEvents = importCalendarEvents;
    notifyListeners();
    _keyValueService.setValue(IMPORT_CALENDAR_EVENTS, _importCalendarEvents);
  }

  Future<List<Calendar>> calendarList() => _eventRepository.calendarList();

  Calendar get selectedCalendar => _calendarService.getSelectedCalendar();
  set selectedCalendar(Calendar calendar) {
    _calendarService.selectCalendar(calendar).then((_) => notifyListeners());
  }

  Future<void> _enableHomeworkNotifications() async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'homework_reminder',
      'Homework Reminder',
      'Reminder to check your homework.',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    for (int i = 0; i < 7; i++) {
      if (homeworkReminderDays[i] == false) continue;
      print(
        'Setting reminder on day ${notificationDayFromIndex(i).value} at '
        'time $homeworkReminderTime',
      );
      await _localNotificationsPlugin.showWeeklyAtDayAndTime(
        // Notification id
        i + 1,
        // Title
        'Homework reminder',
        // Description
        'Don\'t forget to check your upcoming homework!',
        // Notification day
        notificationDayFromIndex(i),
        // Time
        Time(homeworkReminderTime.hour, homeworkReminderTime.minute),
        // Settings
        platformChannelSpecifics,
      );
    }
    print('Homework reminders enabled');
  }

  Day notificationDayFromIndex(int index) {
    Day day;
    switch (index) {
      case 0:
        day = Day.Monday;
        break;
      case 1:
        day = Day.Tuesday;
        break;
      case 2:
        day = Day.Wednesday;
        break;
      case 3:
        day = Day.Thursday;
        break;
      case 4:
        day = Day.Friday;
        break;
      case 5:
        day = Day.Saturday;
        break;
      case 6:
        day = Day.Sunday;
        break;
    }
    return day;
  }

  /// Disables all homework reminder notifications
  Future<void> _disableHomeworkNotifications() async {
    for (int i = 1; i <= 7; i++) {
      await _localNotificationsPlugin.cancel(i);
    }
    print('Homework reminders disabled');
  }

  Future<void> _updateHomeworkNotifications() async {
    if (homeworkReminders == false) return;
    await _disableHomeworkNotifications();
    await _enableHomeworkNotifications();
  }
}
