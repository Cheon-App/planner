import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar.dart';
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/unions/calendar_group_union.dart';
import 'package:flutter/material.dart';

class CalendarVM extends ChangeNotifier {
  CalendarVM() {
    _calendarService.selectedCalendarIdsStream.listen((selectedCalendarIds) {
      _selectedCalendarIds = selectedCalendarIds;
      notifyListeners();
    });
  }
  final _calendarService = container<CalendarService>();

  Set<String> _selectedCalendarIds = {};

  bool calendarIsSelected(Calendar calendar) =>
      _calendarService.selectedCalendarIdsStream.value.contains(calendar.id);

  void selectCalendar(Calendar calendar) =>
      _calendarService.selectCalendar(calendar);

  void deselectCalendar(Calendar calendar) =>
      _calendarService.deselectCalendar(calendar);

  CalendarGroupUnion get calendarGroups => _calendarGroups;
  CalendarGroupUnion _calendarGroups = CalendarGroupUnion.loading();

  Future<void> fetchCalendars() async {
    final groups = await _calendarService.calendarList();
    if (groups != null) {
      _calendarGroups = CalendarGroupUnion.data(groups);
    } else {
      _calendarGroups = CalendarGroupUnion.noPermission();
    }
    notifyListeners();
  }
}
