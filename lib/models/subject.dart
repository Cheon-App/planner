// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/teacher.dart';

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
  });

  factory Subject.fromDBModel({
    @required SubjectModel subjectModel,
    @required Teacher teacher,
  }) {
    assert(subjectModel != null);
    return Subject(
      id: subjectModel.id,
      name: subjectModel.name,
      color: subjectModel.color,
      icon: subjectIconMap[subjectModel.iconId],
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

  // Optional properties
  /// The room lessons of this subject take place in
  final String room;

  /// The teacher lessons of this subject take place in
  final Teacher teacher;

  @override
  List<Object> get props => <Object>[id];
}
