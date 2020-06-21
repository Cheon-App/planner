// Package imports:
import 'package:rxdart/rxdart.dart' hide Subject;

// Project imports:
import 'package:cheon/database/daos/lesson_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/repositories/timetable_repository.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/core/dates/date_utils.dart';

class LessonRepository {
  LessonRepository._internal() {
    timetableFromDateStream(DateTime.now())
        .switchMap(_dao.lessonListFromTimetableStream)
        .listen(_activeLessonListSubject.add);

    _dao.lessonListStream().listen(_lessonListSubject.add);
  }

  static LessonRepository get instance => _singleton;
  static final LessonRepository _singleton = LessonRepository._internal();

  final TimetableRepository _timetableRepository = TimetableRepository.instance;

  final LessonDao _dao = container<Database>().lessonDao;

  final KeyValueService _timetableKeyValueService =
      container<KeyValueService>('timetable');

  Stream<List<Lesson>> lessonListFromDateStream(DateTime date) {
    return timetableFromDateStream(date).switchMap(
      (Timetable dateTimetable) {
        return dateTimetable != null
            ? _dao.lessonListFromDayStream(date.weekday, dateTimetable)
            : Stream<List<Lesson>>.value(<Lesson>[]);
      },
    );
  }

  Stream<Timetable> timetableFromDateStream(DateTime date) {
    void print(Object object) {}
    // TODO unit test this
    // TODO fix term support
    print('-------------------------------------------------------');
    print('Date is $date');
    final bool autoSwitch =
        _timetableKeyValueService.getValue('auto_switch') ?? true;
    print('AutoSwitch: $autoSwitch');
    if (!autoSwitch) {
      return _timetableRepository.activeTimetableStream;
    }

    return CombineLatestStream.combine2(
      _timetableRepository.activeTimetableStream,
      _timetableRepository.timetableListStream,
      (
        Timetable activeTimetable,
        List<Timetable> timetableList,
      ) {
        print('Combined Streams: ');
        print('\tActiveTimetable: ${activeTimetable.id.substring(0, 4)}');
        print('\tTimetableList: '
            '${timetableList.map((e) => e.id.substring(0, 4)).toList()}');
        final DateTime weekStart = strippedDateTime(date.startOfWeek());
        final DateTime timetableWeekStart =
            strippedDateTime(activeTimetable.lastSelected.startOfWeek());
        // positive if week start occurs after timetableWeekStart
        final int dayDiff = weekStart.difference(timetableWeekStart).inDays;

        // Important to round instead of assuming integer division is possible
        // as daylight savings add/remove hours from a day thus days from
        // the difference
        final int weekDiff =
            (weekStart.difference(timetableWeekStart).inDays / 7).round();

        print('WeekStart: $weekStart');
        print('TimetableWeekStart: $timetableWeekStart');
        print('DayDiff: $dayDiff');
        print('WeekDiff: $weekDiff');

        if (weekDiff == 0) {
          // The week start and timetable week start are
          return activeTimetable;
        }

        if (timetableList.length == 1) {
          // There is only one timetable so no further calculations are
          // required to determine the timetable the provided date belongs
          // to
          print('Only one timetable found');
          return activeTimetable;
        }

        final bool startIsAfterTimetableStart = !weekDiff.isNegative;
        final int positiveWeekDiff = weekDiff.abs();
        print('StartIsAfterTimetableStart: $startIsAfterTimetableStart');

        if (startIsAfterTimetableStart) {
          // start at the activeTimetable and step forward to the correct
          // timetable
          final int index =
              (timetableList.indexOf(activeTimetable) + weekDiff) %
                  timetableList.length;
          print('Index: $index');
          return timetableList[index];
        } else {
          final int activeTimetableIndex =
              timetableList.indexOf(activeTimetable);
          final int diff = positiveWeekDiff % timetableList.length;

          // If we cannot subtract diff from the activeTimetableIndex and remain
          // in range of the list then we split the process into two steps.
          // 1. Move to the start of the list and subtract the amount of places
          // moved from the diff
          // 2. Move [step] positions from the end of the list
          if ((activeTimetableIndex - diff).isNegative) {
            // the amount of positions to jump back from the end of the list
            final int step = diff - activeTimetableIndex;
            return timetableList[timetableList.length - step];
          } else {
            return timetableList[activeTimetableIndex - diff];
          }
        }
      },
    );
  }

  final BehaviorSubject<List<Lesson>> _lessonListSubject =
      BehaviorSubject<List<Lesson>>();
  Stream<List<Lesson>> get lessonListStream => _lessonListSubject.stream;

  final BehaviorSubject<List<Lesson>> _activeLessonListSubject =
      BehaviorSubject<List<Lesson>>();
  Stream<List<Lesson>> get activeLessonListStream =>
      _activeLessonListSubject.stream;
}
