import 'package:cheon/database/daos/timetable_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/lesson_time.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class TimetableRepository {
  TimetableRepository._internal() {
    _dao.timetableListStream().listen(_timetableListSubject.add);
    _dao.activeTimetableStream().listen(_activeTimetableSubject.add);
    _dao.lessonTimeListStream().listen(_lessonTimeListSubject.add);
  }

  static TimetableRepository get instance => _singleton;

  static final TimetableRepository _singleton = TimetableRepository._internal();

  final TimetableDao _dao = container<Database>().timetableDao;

  Future<void> addTimetable(int index) => _dao.addTimetable(index);

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
      await addTimetable(1);
      // Adds 5 default lesson times.
      for (int i = 1; i <= 5; i++) {
        await addLessonTime(i, DateTime(0, 0, 0, 8 + i, 0));
      }
    }
  }

  Future<void> switchTimetable(Timetable timetable) =>
      _dao.switchTimetable(timetable);

  Future<void> addLessonTime(int index, DateTime startTime) =>
      _dao.addLessonTime(index, startTime);

  Future<void> updateLessonTime(LessonTime lessonTime, DateTime startTime) =>
      _dao.updateLessonTime(lessonTime, startTime);

  Future<void> deleteLessonTime(int period) => _dao.deleteLessonTime(period);

  Future<void> addLesson({
    Subject subject,
    Teacher teacher,
    String room,
    String note,
    int weekday,
    int period,
    Timetable timetable,
  }) =>
      _dao.addLesson(
        subject: subject,
        teacher: teacher,
        room: room,
        note: note,
        weekday: weekday,
        period: period,
        timetable: timetable,
      );

  Future<void> updateTimetable(
    Timetable timetable, {
    bool showSaturday,
    bool showSunday,
  }) =>
      _dao.updateTimetable(
        timetable,
        showSaturday: showSaturday,
        showSunday: showSunday,
      );

  Future<void> deleteTimetable(Timetable timetable) =>
      _dao.deleteTimetable(timetable);
}
