import 'package:cheon/database/daos/lesson_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/inset_day.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/repositories/timetable_repository.dart';
import 'package:cheon/repositories/year_repository.dart';
import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:cheon/utils.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

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
  final YearRepository _yearRepository = YearRepository.instance;

  final LessonDao _dao = Database.instance.lessonDao;

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

  bool dayIsInTermList(DateTime date, List<Term> termList) {
    date = strippedDateTime(date);
    bool dayIsInTerm = false;
    for (Term term in termList) {
      final bool afterOrAtStart =
          term.start.isBefore(date) || term.start.isAtSameMomentAs(date);
      final bool beforeOrAtEnd =
          term.end.isAfter(date) || term.end.isAtSameMomentAs(date);

      if (afterOrAtStart || beforeOrAtEnd) {
        dayIsInTerm = true;
        break;
      }
    }
    return dayIsInTerm;
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

    return CombineLatestStream.combine4(
      _timetableRepository.activeTimetableStream,
      _timetableRepository.timetableListStream,
      _yearRepository.termListStream,
      _yearRepository.insetDayListStream,
      (
        Timetable activeTimetable,
        List<Timetable> timetableList,
        List<Term> termList,
        List<InsetDay> insetDayList,
      ) {
        /// If the provided date is an inset day then no lessons occur so no
        /// timetable is provided.
        date = strippedDateTime(date);
        for (InsetDay insetDay in insetDayList) {
          if (strippedDateTime(insetDay.date).isAtSameMomentAs(date)) {
            return null;
          }
        }

        print('Combined Streams: ');
        print('\tActiveTimetable: ${activeTimetable.id.substring(0, 4)}');
        print('\tTimetableList: '
            '${timetableList.map((e) => e.id.substring(0, 4)).toList()}');
        print('\tTermList: ${termList.map((e) => e.id).toList()}');
        final DateTime weekStart = strippedDateTime(startOfWeek(date));
        final DateTime timetableWeekStart =
            strippedDateTime(startOfWeek(activeTimetable.lastSelected));
        // positive if week start occurs after timetableWeekStart
        final int dayDiff = weekStart.difference(timetableWeekStart).inDays;

        // Important to round instead of assuming integer division is possible
        // as daylight savings add/remove hours from a day thus days from
        // the difference
        int weekDiff =
            (weekStart.difference(timetableWeekStart).inDays / 7).round();

        final bool switchInHolidays =
            _timetableKeyValueService.getValue('switch_in_holidays') ?? false;
        print('SwitchInHolidays: $switchInHolidays');

        print('WeekStart: $weekStart');
        print('TimetableWeekStart: $timetableWeekStart');
        print('DayDiff: $dayDiff');
        print('WeekDiff: $weekDiff');

        if (switchInHolidays == false) {
          // I.E. Ignore holidays
          // No timetable is assigned to weeks that do not lie within a term
          // therefore the weekDiff should be adjusted accordingly
          final bool dayIsInTerm = dayIsInTermList(date, termList);

          if (dayIsInTerm == false) {
            // The provided day is outside of a term and the timetable isn't
            // being switched for weeks that lie outside of a term so no
            // timetable belongs to this day.
            return null;
          }

          // Accounts for holidays by decrementing the weekDiff for every week
          // that occurs in a holiday
          for (int i = 0; i < weekDiff; i++) {
            final DateTime date =
                (weekDiff.isNegative ? weekStart : timetableWeekStart).add(
              Duration(days: i * 7),
            );
            final bool dayIsInTerm = dayIsInTermList(date, termList);
            if (!dayIsInTerm) {
              weekDiff--;
            }
          }
        }

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

  Stream<List<Lesson>> lessonListFromSubjectStream(Subject subject) {
    return _dao.lessonListFromSubjectStream(subject);
  }

  final BehaviorSubject<List<Lesson>> _lessonListSubject =
      BehaviorSubject<List<Lesson>>();
  Stream<List<Lesson>> get lessonListStream => _lessonListSubject.stream;

  final BehaviorSubject<List<Lesson>> _activeLessonListSubject =
      BehaviorSubject<List<Lesson>>();
  Stream<List<Lesson>> get activeLessonListStream =>
      _activeLessonListSubject.stream;

  Future<void> updateLesson(Lesson lesson, {String room, String note}) =>
      _dao.updateLesson(lesson, room: room, note: note);

  Future<void> deleteLesson(Lesson lesson) => _dao.deleteLesson(lesson);
}
