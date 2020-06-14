// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/models/assessment.dart';
import 'package:cheon/models/subject.dart';

@immutable
class Exam extends Assessment {
  /// Represents an exam
  Exam({
    @required this.id,
    @required this.subject,
    @required this.title,
    this.location,
    this.seat,
    @required this.start,
    @required this.end,
    @required this.priority,
  })  : assert(subject != null),
        assert(start != null),
        assert(end != null),
        assert(title != null),
        assert(!start.isAtSameMomentAs(end)),
        super(start);

  factory Exam.fromDBModel({
    @required ExamModel examModel,
    @required Subject subject,
  }) {
    return Exam(
      id: examModel.id,
      start: examModel.start,
      end: examModel.end,
      title: examModel.title,
      location: examModel.location,
      seat: examModel.seat,
      subject: subject,
      priority: examModel.priority,
    );
  }

  /// A UUID identifier for the exam
  final String id;

  /// The place where the exam takes place e.g. Exam Hall
  final String location;

  /// The seat code for the exam e.g. A1
  final String seat;

  /// The start of the exam
  final DateTime start;

  /// The end of the exam
  final DateTime end;

  /// Title of the exam e.g. Maths Paper 1
  final String title;

  /// The subject of the exam;
  final Subject subject;

  /// The importance of this exam. 1 to 5.
  final int priority;

  @override
  List<Object> get props => <Object>[id];
}
