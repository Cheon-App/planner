// Dart imports:
import 'dart:collection';

// Package imports:
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar_group.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:device_calendar/device_calendar.dart' as dc;
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/models/calendar.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CalendarService {
  CalendarService() {
    _selectedCalendarsSubject.add(_selectedCalendarIds());
  }

  final dc.DeviceCalendarPlugin _plugin = dc.DeviceCalendarPlugin();
  final _keyValueService = container<KeyValueService>('calendar');

  final _selectedCalendarsSubject = BehaviorSubject<Set<String>>();
  ValueStream<Set<String>> get selectedCalendarIdsStream =>
      _selectedCalendarsSubject.stream;

  Future<bool> handlePermissions() async {
    dc.Result<bool> result = await _plugin.hasPermissions();
    if (result.data == false) {
      result = await _plugin.requestPermissions();
      return result.data;
    } else {
      return true;
    }
  }

  Future<List<CalendarEvent>> eventListFromDate({
    @required DateTime date,
  }) async {
    if (await handlePermissions() == false) return [];

    final calendarIds = _selectedCalendarIds();

    final events = <CalendarEvent>[];

    for (final calendarId in calendarIds) {
      final rawEvents = await _plugin.retrieveEvents(
        calendarId,
        dc.RetrieveEventsParams(
          startDate: date,
          endDate: date.add(const Duration(days: 1)),
        ),
      );

      if (rawEvents?.data != null) {
        events.addAll(
          rawEvents.data
              .where((dc.Event event) => !event.allDay)
              .map(_dcEventToCalendarEvent),
        );
      }
    }

    return events;
  }

  CalendarEvent _dcEventToCalendarEvent(dc.Event event) {
    return CalendarEvent(
      eventId: event.eventId,
      calendarId: event.calendarId,
      start: event.start,
      end: event.end,
      title: event.title,
      // Some descriptions contain metadata starting after -::
      description: event.description.split('-::').first,
      location: event.location,
      uri: event.url,
    );
  }

  Future<List<CalendarGroup>> calendarList() async {
    if (await handlePermissions() == false) return null;

    final dc.Result<UnmodifiableListView<dc.Calendar>> calendarResult =
        await _plugin.retrieveCalendars();

    final calendars = (calendarResult.data ?? <dc.Calendar>[]).map(
      (dc.Calendar calendar) => Calendar(
        id: calendar.id,
        name: calendar.name,
        accountName: calendar.accountName,
        accountType: calendar.accountType,
      ),
    );

    final calendarGroupMap = <String, List<Calendar>>{};

    for (final calendar in calendars) {
      if (calendarGroupMap.containsKey(calendar.accountName)) {
        calendarGroupMap[calendar.accountName].add(calendar);
      } else {
        calendarGroupMap[calendar.accountName] = [calendar];
      }
    }

    final calendarGroups = <CalendarGroup>[];

    for (final group in calendarGroupMap.entries) {
      calendarGroups.add(
        CalendarGroup(name: group.key, calendars: group.value),
      );
    }

    return calendarGroups;
  }

  void selectCalendar(Calendar calendar) {
    print('Selecting $calendar');
    final selectedCalendarIds = {..._selectedCalendarIds()};
    selectedCalendarIds.add(calendar.id);
    _updateSelectedCalendarIds(selectedCalendarIds);
    _selectedCalendarsSubject.add(selectedCalendarIds);
  }

  void deselectCalendar(Calendar calendar) {
    print('Deselecting $calendar');
    final selectedCalendarIds = {..._selectedCalendarIds()};
    selectedCalendarIds.remove(calendar.id);
    _updateSelectedCalendarIds(selectedCalendarIds);
    _selectedCalendarsSubject.add(selectedCalendarIds);
  }

  Future<void> _updateSelectedCalendarIds(Set<String> ids) async {
    final value = ids.join(',');
    await _keyValueService.setValue<String>('selected_calendars', value);
  }

  Set<String> _selectedCalendarIds() =>
      _keyValueService
          .getValue<String>('selected_calendars')
          ?.split(',')
          ?.toSet() ??
      {};
}
