import 'package:cheon/models/calendar.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CalendarGroup implements EquatableMixin {
  const CalendarGroup({@required this.name, @required this.calendars});

  /// Usually an email on Android.
  /// Usually the name of the Calendar app on IOS.
  final String name;
  final List<Calendar> calendars;

  @override
  List<Object> get props => [name, calendars];

  @override
  bool get stringify => true;
}
