// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/models/compare_time.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';

class Lesson extends CompareTime {
  /// Represents a lesson
  Lesson({
    @required this.id,
    @required this.period,
    @required this.subject,
    String room,
    Teacher teacher,
    @required this.startTime,
    @required this.weekday,
    @required this.note,
    @required this.timetable,
    //  The default room and teacher can be overridden
  })  : room = room ?? subject.room,
        teacher = teacher ?? subject.teacher,
        assert(id != null),
        assert(period != null),
        assert(subject != null),
        assert(weekday != null),
        super(startTime);

  factory Lesson.fromDBModel(
    LessonModel model, {
    Timetable timetable,
    Teacher teacher,
    Subject subject,
    DateTime startTime,
  }) {
    return Lesson(
      id: model.id,
      startTime: TimeOfDay.fromDateTime(startTime),
      subject: subject,
      weekday: model.weekday,
      room: model.room,
      note: model.note,
      period: model.period,
      teacher: teacher,
      timetable: timetable,
    );
  }

  /// A UUID identifier for the lesson
  final String id;

  /// The period of the lesson e.g. period 1 for the first lesson of the day
  final int period;

  /// The subject being taught in the lesson
  final Subject subject;

  /// An optional room where the lesson takes place
  final String room;

  /// The teacher teaching the lesson
  final Teacher teacher;

  /// The time when the lesson starts
  final TimeOfDay startTime;

  /// The day of the week that the lesson occurs on. Uses the [DateTime] weekday
  /// format
  final int weekday;

  /// An optional note that can be left for the lesson
  final String note;

  /// The timetable the lesson belongs to
  final Timetable timetable;

  @override
  List<Object> get props => <Object>[id];
}
