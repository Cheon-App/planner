// Flutter imports:
import 'package:cheon/services/calendar_service/calendar_service.dart';
import 'package:cheon/view_models/calendar_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:cheon/core/dates/date_utils.dart';
import 'package:cheon/database/daos/study_dao.dart';
import 'package:cheon/database/daos/task_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/timeline_data.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/repositories/exam_repository.dart';
import 'package:cheon/repositories/lesson_repository.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/view_models/settings_view_model.dart';

class TimelineVM extends ChangeNotifier {
  TimelineVM() {
    selectedDate = DateTime.now().truncateToDay();

    _selectedDateSubject.stream.switchMap(
      (DateTime date) {
        return CombineLatestStream.combine3<int, int, Timetable, void>(
          _taskDao.tasksToGo(date),
          _studyDao.sesionsToGo(date),
          _lessonRepository.timetableFromDateStream(date),
          (int tasksToGo, int sessionsToGo, Timetable timetable) {
            _tasksToGo = tasksToGo;
            _sessionsToGo = sessionsToGo;
            _selectedTimetable = timetable;
          },
        );
      },
    ).listen((_) => notifyListeners());
  }

  final KeyValueService _keyValueService = container<KeyValueService>();
  final TaskDao _taskDao = container<Database>().taskDao;
  final StudyDao _studyDao = container<Database>().studyDao;

  final BehaviorSubject<DateTime> _selectedDateSubject =
      BehaviorSubject<DateTime>();

  final LessonRepository _lessonRepository = LessonRepository.instance;
  final ExamRepository _examRepository = ExamRepository.instance;
  final StudyRepository _studyRepository = StudyRepository.instance;
  final _calendarService = container<CalendarService>();

  /// A stream of [TimelineData] i.e. data consumed by the timeline page.
  Stream<TimelineData> timelineDataStream() => _selectedDateSubject.stream
      .distinct()
      .switchMap(
        (DateTime date) => CombineLatestStream.combine4(
          _lessonRepository.lessonListFromDateStream(date).doOnError((_) => []),
          _examRepository.examListFromDateStream(date).doOnError((_) => []),
          _studyRepository
              .studySessionListFromDateStream(date)
              .doOnError((_) => []),
          _keyValueService.getValue(SettingsVM.IMPORT_CALENDAR_EVENTS) ?? false
              ? _calendarService
                  .eventListFromDate(date: date)
                  .asStream()
                  .doOnError((_) => [])
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

  int _sessionsToGo = 0;
  int get sessionsToGo => _sessionsToGo;
  int _tasksToGo = 0;
  int get tasksToGo => _tasksToGo;

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
