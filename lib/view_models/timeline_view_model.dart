import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/timeline_data.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/repositories/event_repository.dart';
import 'package:cheon/repositories/exam_repository.dart';
import 'package:cheon/repositories/lesson_repository.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/preferences_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TimelineVM extends ChangeNotifier {
  TimelineVM() {
    selectedDate = DateTime.now().truncateToDay();

    _selectedDateSubject.stream.switchMap(_taskDao.tasksDue).listen((count) {
      _tasksDue = count;
      notifyListeners();
    });

    _selectedDateSubject.stream
        .switchMap(_lessonRepository.timetableFromDateStream)
        .listen(
      (Timetable timetable) {
        _selectedTimetable = timetable;
        notifyListeners();
      },
    );
  }

  final KeyValueService _keyValueService = container<KeyValueService>();
  final _taskDao = container<Database>().taskDao;

  final BehaviorSubject<DateTime> _selectedDateSubject =
      BehaviorSubject<DateTime>();

  final LessonRepository _lessonRepository = LessonRepository.instance;
  final ExamRepository _examRepository = ExamRepository.instance;
  final EventRepository _eventRepository = EventRepository.instance;
  final StudyRepository _studyRepository = StudyRepository.instance;

  /// A stream of [TimelineData] i.e. data consumed by the timeline page.
  Stream<TimelineData> timelineDataStream() =>
      _selectedDateSubject.stream.distinct().switchMap(
            (DateTime date) => CombineLatestStream.combine4(
              _lessonRepository.lessonListFromDateStream(date),
              _examRepository.examListFromDateStream(date),
              _studyRepository.studySessionListFromDateStream(date),
              _keyValueService.getValue(Preferences.IMPORT_CALENDAR_EVENTS) ??
                      false
                  ? _eventRepository.eventListStreamFromDate(date).asStream()
                  : Stream<List<CalendarEvent>>.value(<CalendarEvent>[]),
              (
                List<Lesson> lessonList,
                List<Exam> examList,
                List<StudySession> studySessionList,
                List<CalendarEvent> eventList,
              ) {
                return TimelineData(
                  lessonList: lessonList,
                  examList: examList,
                  eventList: eventList,
                  studySessionList: studySessionList,
                );
              },
            ),
          );

  int _tasksDue;

  /// The amount of tasks due
  int get tasksDue => _tasksDue;

  DateTime _selectedDate;

  /// The date events are currently being shown for
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime date) {
    assert(date != null);
    _selectedDate = date;
    _selectedDateSubject.add(_selectedDate);
    notifyListeners();
  }

  Timetable _selectedTimetable;

  /// The timetable events are being shown for
  Timetable get selectedTimetable => _selectedTimetable;
}
