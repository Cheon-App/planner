// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/study_session.dart';

@immutable
class TimelineData {
  /// A collection of lists consumed by the [TimelinePage]
  const TimelineData({
    @required this.lessonList,
    @required this.examList,
    @required this.eventList,
    @required this.studySessionList,
  })  : assert(lessonList != null),
        assert(examList != null),
        assert(eventList != null),
        assert(studySessionList != null);

  /// A list of lessons
  final List<Lesson> lessonList;

  /// A list of exams
  final List<Exam> examList;

  /// A list of events
  final List<CalendarEvent> eventList;

  /// A list of study sessions
  final List<StudySession> studySessionList;

  bool get isEmpty =>
      lessonList.isEmpty &&
      examList.isEmpty &&
      eventList.isEmpty &&
      studySessionList.isEmpty;
}
