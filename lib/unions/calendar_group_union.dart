import 'package:cheon/models/calendar_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_group_union.freezed.dart';

@immutable
@freezed
abstract class CalendarGroupUnion with _$CalendarGroupUnion {
  const factory CalendarGroupUnion.loading() = _Loading;
  const factory CalendarGroupUnion.data(List<CalendarGroup> calendarGroups) =
      _Data;
  const factory CalendarGroupUnion.noPermission() = _NoPermission;
}
