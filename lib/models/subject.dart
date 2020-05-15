import 'dart:ui';

import 'package:cheon/constants.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/year.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class Subject extends Equatable {
  /// Represents a subject
  const Subject({
    @required this.id,
    @required this.name,
    @required this.color,
    this.room,
    this.teacher,
    this.icon,
    this.year,
  });

  factory Subject.fromDBModel({
    @required SubjectModel subjectModel,
    @required Year year,
    @required Teacher teacher,
  }) {
    assert(subjectModel != null);
    assert(year != null);
    return Subject(
      id: subjectModel.id,
      name: subjectModel.name,
      color: subjectModel.color,
      icon: subjectIconMap[subjectModel.iconId],
      year: year,
      // Optional
      room: subjectModel.room,
      teacher: teacher,
    );
  }

  /// A UUID identifier for the subject
  final String id;

  /// The name of the subject
  final String name;

  /// A chosen color that represents this subject
  final Color color;

  /// A chosen icon that represent this subject
  final IconData icon;

  /// The year that this subject belongs to
  final Year year;

  // Optional properties
  /// The room lessons of this subject take place in
  final String room;

  /// The teacher lessons of this subject take place in
  final Teacher teacher;

  @override
  List<Object> get props => <Object>[id];
}
