import 'package:cheon/database/database.dart';
import 'package:cheon/models/year.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Timetable extends Equatable {
  /// Represents a lesson timetable
  const Timetable({
    @required this.id,
    @required this.year,
    @required this.week,
    @required this.saturdayEnabled,
    @required this.sundayEnabled,
    @required this.lastSelected,
  });

  factory Timetable.fromDBModel(TimetableModel model, Year year) {
    return Timetable(
      id: model.id,
      week: model.week,
      saturdayEnabled: model.saturday,
      sundayEnabled: model.sunday,
      year: year,
      lastSelected: model.lastSelected,
    );
  }

  /// A UUID identifier for this timetable
  final String id;

  /// The year this timetable belongs to
  final Year year;

  /// Used to order a list of timetables
  final int week;

  /// True if the timetable shows Saturdays
  final bool saturdayEnabled;

  /// True if the timetable shows Sundays
  final bool sundayEnabled;

  /// The last time this timetable was selected by the user
  final DateTime lastSelected;

  @override
  List<Object> get props => <Object>[id];
}
