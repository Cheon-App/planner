import 'dart:collection';
import 'dart:convert';

import 'package:cheon/models/calendar.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:device_calendar/device_calendar.dart' as dc;
import 'package:meta/meta.dart';

class DeviceCalendarService implements CalendarService {
  DeviceCalendarService({@required KeyValueService keyValueService})
      : _keyValueService = keyValueService;

  final dc.DeviceCalendarPlugin _plugin = dc.DeviceCalendarPlugin();
  final KeyValueService _keyValueService;
  static const String SELECTED_CALENDAR = 'selected_calendar';

  Future<bool> handlePermissions() async {
    dc.Result<bool> result = await _plugin.hasPermissions();
    if (result.data == false) {
      result = await _plugin.requestPermissions();
      return result.data;
    } else {
      return true;
    }
  }

  @override
  Future<List<CalendarEvent>> eventListFromDate(DateTime date) async {
    if (await handlePermissions() == false) return null;

    final String calendarId = getSelectedCalendar()?.id;

    if (calendarId == null) return null;

    final dc.Result<UnmodifiableListView<dc.Event>> eventResult =
        await _plugin.retrieveEvents(
      calendarId,
      dc.RetrieveEventsParams(
        startDate: date,
        endDate: date.add(const Duration(days: 1)),
      ),
    );
    final List<dc.Event> events = eventResult.data?.toList();
    if (events == null) return null;

    return events
        .where((dc.Event event) => !event.allDay)
        .map((dc.Event event) => CalendarEvent(
              eventId: event.eventId,
              calendarId: event.calendarId,
              start: event.start,
              end: event.end,
              title: event.title,
              description: event.description,
              location: event.location,
            ))
        .toList();
  }

  @override
  Future<List<Calendar>> calendarList() async {
    if (await handlePermissions() == false) return null;

    final dc.Result<UnmodifiableListView<dc.Calendar>> calendarResult =
        await _plugin.retrieveCalendars();

    return (calendarResult.data ?? <dc.Calendar>[])
        .map((dc.Calendar calendar) => Calendar(
              id: calendar.id,
              name: calendar.name,
              accountName: calendar.accountName,
              accountType: calendar.accountType,
            ))
        .toList();
  }

  @override
  Future<void> selectCalendar(Calendar calendar) async {
    await _keyValueService.setValue(
      SELECTED_CALENDAR,
      jsonEncode(calendar.toJson()),
    );
  }

  @override
  Calendar getSelectedCalendar() {
    final dynamic calendarJson = _keyValueService.getValue(SELECTED_CALENDAR);
    if (calendarJson == null) return null;
    return Calendar.fromJson(jsonDecode(calendarJson));
  }
}
