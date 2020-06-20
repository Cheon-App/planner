// Package imports:
import 'package:rxdart/rxdart.dart' hide Subject;

// Project imports:
import 'package:cheon/database/daos/timetable_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/lesson_time.dart';
import 'package:cheon/models/timetable.dart';

class TimetableRepository {
  TimetableRepository._internal() {
    _dao.timetableListStream().listen(_timetableListSubject.add);
    _dao.activeTimetableStream().listen(_activeTimetableSubject.add);
    _dao.lessonTimeListStream().listen(_lessonTimeListSubject.add);
  }

  static TimetableRepository get instance => _singleton;
  static final TimetableRepository _singleton = TimetableRepository._internal();
  final TimetableDao _dao = container<Database>().timetableDao;

  final BehaviorSubject<List<Timetable>> _timetableListSubject =
      BehaviorSubject<List<Timetable>>();
  Stream<List<Timetable>> get timetableListStream =>
      _timetableListSubject.stream;

  final BehaviorSubject<Timetable> _activeTimetableSubject =
      BehaviorSubject<Timetable>();
  Stream<Timetable> get activeTimetableStream => _activeTimetableSubject.stream;

  final BehaviorSubject<List<LessonTime>> _lessonTimeListSubject =
      BehaviorSubject<List<LessonTime>>();
  Stream<List<LessonTime>> get lessonTimeListStream =>
      _lessonTimeListSubject.stream;

  Future<void> init() async {
    if (await _dao.hasTimetables() == false) {
      await _dao.addTimetable(1);
      // Adds 5 default lesson times.
      for (int i = 1; i <= 5; i++) {
        await _dao.addLessonTime(i, DateTime(0, 0, 0, 8 + i, 0));
      }
    }
  }
}
