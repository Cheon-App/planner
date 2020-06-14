// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/models/timetable.dart';

@immutable
class TimetablePosition extends Equatable {
  /// Represents a position on the timetable grid
  const TimetablePosition({
    @required this.weekday,
    @required this.period,
    @required this.timetable,
  })  : assert(weekday != null),
        assert(period != null);

  /// The weekday of the timetable position. Uses the [DateTime] weekday format
  final int weekday;

  /// The period of the timetable position. E.g. Period 1 = the first lesson of
  /// the day
  final int period;

  /// The timetable this timetable position belongs to
  final Timetable timetable;

  @override
  List<Object> get props => <Object>[weekday, period, timetable];
}
