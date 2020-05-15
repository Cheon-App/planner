import 'package:cheon/database/database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LessonTime extends Equatable {
  /// Represents a timeslot in which a lesson occurs
  const LessonTime({@required this.period, @required this.time})
      : assert(period != null, time != null);

  factory LessonTime.fromDBModel(LessonTimeModel model) {
    return LessonTime(
      period: model.period,
      time: TimeOfDay.fromDateTime(model.startTime),
    );
  }

  /// The period that the lesson time belongs to. period 1 = 1st lesson
  final int period;

  /// The start time of the lesson
  final TimeOfDay time;

  @override
  List<Object> get props => <Object>[period, time];
}
