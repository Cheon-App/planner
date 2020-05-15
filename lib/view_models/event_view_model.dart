import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';

class EventVM {
  EventVM();

  final KeyValueService _keyValueService = container<KeyValueService>('event');

  Calendar selectedCalendar;
}
