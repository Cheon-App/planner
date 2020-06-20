// Flutter imports:
import 'package:cheon/database/daos/timetable_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/lesson_time.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/repositories/lesson_repository.dart';
import 'package:cheon/repositories/timetable_repository.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';

class TimetableVM extends ChangeNotifier {
  TimetableVM() {
    _autoSwitch = _keyValueService.getValue(KEY_AUTO_SWITCH) ?? true;
    _switchInHolidays =
        _keyValueService.getValue(KEY_SWITCH_IN_HOLIDAYS) ?? false;
    _useLetters = _keyValueService.getValue(KEY_USE_LETTERS) ?? false;
    _lessonLength = Duration(
      minutes: _keyValueService.getValue(KEY_LESSON_LENGTH) ?? 60,
    );

    lessonTimeListStream.listen((List<LessonTime> lessonTimeList) {
      _lessonsPerDay = lessonTimeList?.length ?? 0;
      notifyListeners();
    });
  }

  static const String KEY_AUTO_SWITCH = 'auto_switch';
  static const String KEY_SWITCH_IN_HOLIDAYS = 'switch_in_holidays';
  static const String KEY_USE_LETTERS = 'use_letters';
  static const String KEY_LESSON_LENGTH = 'lesson_length';

  final TimetableRepository _timetableRepository = TimetableRepository.instance;
  final LessonRepository _lessonRepository = LessonRepository.instance;
  final TimetableDao _dao = container<Database>().timetableDao;

  final KeyValueService _keyValueService =
      container<KeyValueService>('timetable');

  bool _autoSwitch;
  bool get autoSwitch => _autoSwitch;
  set autoSwitch(bool autoSwitch) {
    if (autoSwitch == _autoSwitch) return;
    _autoSwitch = autoSwitch;
    notifyListeners();
    _keyValueService.setValue(KEY_AUTO_SWITCH, autoSwitch);
  }

  bool _switchInHolidays;
  bool get switchInHolidays => _switchInHolidays;
  set switchInHolidays(bool switchInHolidays) {
    if (switchInHolidays == _switchInHolidays) return;
    _switchInHolidays = switchInHolidays;
    notifyListeners();
    _keyValueService.setValue(
      KEY_SWITCH_IN_HOLIDAYS,
      switchInHolidays,
    );
  }

  bool _useLetters;
  bool get useLetters => _useLetters;
  set useLetters(bool useLetters) {
    if (useLetters == _useLetters) return;
    _useLetters = useLetters;
    notifyListeners();
    _keyValueService.setValue(KEY_USE_LETTERS, useLetters);
  }

  Duration _lessonLength;
  Duration get lessonLength => _lessonLength;
  set lessonLength(Duration lessonLength) {
    if (lessonLength == _lessonLength) return;
    _lessonLength = lessonLength;
    notifyListeners();
    _keyValueService.setValue(
      KEY_LESSON_LENGTH,
      lessonLength.inMinutes,
    );
  }

  int _lessonsPerDay = 1;
  int get lessonsPerDay => _lessonsPerDay;

  Future<void> addTimetable({@required int index}) => _dao.addTimetable(index);

  Stream<List<Timetable>> get timetableListStream =>
      _timetableRepository.timetableListStream;
  Stream<Timetable> get activeTimetableStream =>
      _timetableRepository.activeTimetableStream;
  Stream<List<Lesson>> get activeLessonListStream =>
      _lessonRepository.activeLessonListStream;

  Stream<List<LessonTime>> get lessonTimeListStream =>
      _timetableRepository.lessonTimeListStream;

  Future<void> switchTimetable(Timetable timetable) =>
      _dao.switchTimetable(timetable);

  Future<void> addLessonTime(int index, DateTime startTime) =>
      _dao.addLessonTime(index, startTime);

  Future<void> updateLessonTime(LessonTime lessonTime, DateTime startTime) =>
      _dao.updateLessonTime(lessonTime, startTime);

  Future<void> deleteLessonTime(int period) => _dao.deleteLessonTime(period);

  Future<void> addLesson({
    @required Subject subject,
    @required Teacher teacher,
    @required String room,
    @required String note,
    @required int weekday,
    @required int period,
    @required Timetable timetable,
  }) {
    return _dao.addLesson(
      subject: subject,
      teacher: teacher,
      room: room,
      note: note,
      weekday: weekday,
      period: period,
      timetable: timetable,
    );
  }

  Future<void> updateTimetable(
    Timetable timetable, {
    bool showSaturday,
    bool showSunday,
  }) {
    return _dao.updateTimetable(
      timetable,
      showSaturday: showSaturday,
      showSunday: showSunday,
    );
  }

  Future<void> deleteTimetable(Timetable timetable) =>
      _dao.deleteTimetable(timetable);
}
