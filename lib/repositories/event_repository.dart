import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';

class EventRepository {
  EventRepository._internal();

  static EventRepository get instance => _singleton;

  static final EventRepository _singleton = EventRepository._internal();

  final CalendarService _calendarService = container<CalendarService>();

  Future<List<CalendarEvent>> eventListStreamFromDate(DateTime date) async =>
      await _calendarService.eventListFromDate(date) ?? <CalendarEvent>[];

  Future<List<Calendar>> calendarList() async =>
      await _calendarService.calendarList() ?? <Calendar>[];
}
