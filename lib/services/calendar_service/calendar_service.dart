import 'package:cheon/models/calendar.dart';
import 'package:cheon/models/calendar_event.dart';

abstract class CalendarService {
  Future<List<CalendarEvent>> eventListFromDate(DateTime date);
  Future<List<Calendar>> calendarList();
  Future<void> selectCalendar(Calendar calendar);
  Calendar getSelectedCalendar();
}
