import 'package:cheon/database/database.dart';
import 'package:cheon/models/event.dart';
import 'package:cheon/models/subject.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Homework extends Equatable {
  /// Represents a piece of homework.
  const Homework({
    @required this.id,
    @required this.due,
    @required this.subject,
    @required this.title,
    @required this.description,
    @required this.length,
    @required this.progress,
    this.scheduled,
  })  : assert(due != null),
        assert(subject != null),
        assert(title != null),
        assert(length != null),
        assert(progress != null),
        assert(progress >= 0 && progress <= 1);

  factory Homework.fromDBModel({
    @required HomeworkModel homeworkModel,
    @required Subject subject,
  }) {
    return Homework(
      id: homeworkModel.id,
      due: homeworkModel.due,
      length: Duration(minutes: homeworkModel.length),
      progress: homeworkModel.progress,
      subject: subject,
      title: homeworkModel.title,
      description: homeworkModel.description,
    );
  }

  /// A UUID identifier for the homework
  final String id;

  /// The due date.
  final DateTime due;

  /// The subject the homework is related to.
  final Subject subject;

  /// The title of the homework.
  final String title;

  /// What the homework involves.
  final String description;

  /// An estimate of how long it will take to complete the homework.
  final Duration length;

  /// The fraction representing how much of the homework has been completed.
  final double progress;

  /// The optional event linked to the homework if it has been scheduled.
  final Event scheduled;

  /// Returns true if the homework has been completed.
  bool complete() => progress == 1;

  /// Returns true if the homework has an event associated with it.
  bool planned() => scheduled != null;

  @override
  List<Object> get props => <Object>[id];
}
