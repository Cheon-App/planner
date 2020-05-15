import 'package:cheon/database/database.dart';
import 'package:cheon/models/compare_date_time.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/test.dart';
import 'package:meta/meta.dart';

@immutable
class StudySession extends CompareDateTime {
  /// Represents a period of time where the user can study for a subject
  StudySession({
    @required this.id,
    @required this.start,
    @required this.end,
    @required this.completed,
    @required this.exam,
    @required this.test,
  }) : super(start);

  factory StudySession.fromDBModel(StudyModel studyModel,
      {Exam exam, Test test}) {
    return StudySession(
      id: studyModel.id,
      start: studyModel.start,
      end: studyModel.end,
      completed: studyModel.completed,
      exam: exam,
      test: test,
    );
  }

  bool forExam() => exam != null;
  bool forTest() => test != null;

  Subject get subject => exam?.subject ?? test?.subject;

  String get title => exam?.title ?? test?.name;

  Duration get duration => end.difference(start);

  /// The uuid identifer of the study session
  final String id;

  /// The start time of the study session
  final DateTime start;

  /// The end time of the study session
  final DateTime end;

  /// True if the study session has been completed
  final bool completed;

  /// The Exam this study session is for if it's for an exam
  final Exam exam;

  /// The Test this study session is for if it's for an test
  final Test test;
}
