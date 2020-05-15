import 'package:cheon/database/database.dart';
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/lesson_time.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'timetable_dao.g.dart';

@UseDao(tables: <Type>[Timetables, Lessons, LessonTimes, Years])
class TimetableDao extends DatabaseAccessor<Database> with _$TimetableDaoMixin {
  TimetableDao(Database db) : super(db);

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  Stream<List<Timetable>> timetableListStream() {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (select(timetables)
            ..where(
              ($TimetablesTable table) => table.yearId.equals(
                uuidToUint8List(yearModel.id),
              ),
            )
            ..orderBy(<OrderingTerm Function($TimetablesTable)>[
              ($TimetablesTable table) => OrderingTerm(
                    expression: table.week,
                    mode: OrderingMode.asc,
                  )
            ]))
          .map(
            (TimetableModel timetableModel) => Timetable.fromDBModel(
              timetableModel,
              Year.fromDBModel(yearModel),
            ),
          )
          .watch();
    });
  }

  Stream<Timetable> activeTimetableStream() {
    // TODO account for auto switching
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (select(timetables)
            ..where(
              ($TimetablesTable table) => table.yearId.equals(
                uuidToUint8List(yearModel.id),
              ),
            )
            ..orderBy(<OrderingTerm Function($TimetablesTable)>[
              ($TimetablesTable table) => OrderingTerm(
                    expression: table.lastSelected,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(1))
          .map(
            (TimetableModel timetableModel) => Timetable.fromDBModel(
              timetableModel,
              Year.fromDBModel(yearModel),
            ),
          )
          .watchSingle();
    });
  }

  Future<void> addTimetable(int index, Year year) async {
    final DateTime now = DateTime.now();
    await into(timetables).insert(TimetableModel(
      id: generateUUID(),
      yearId: year.id,
      saturday: false,
      sunday: false,
      week: index,
      lastSelected: now,
      lastUpdated: now,
    ));
  }

  Future<void> switchTimetable(Timetable timetable) {
    final TimetablesCompanion companion = TimetablesCompanion(
      id: Value<String>(timetable.id),
      lastSelected: Value<DateTime>(DateTime.now()),
    );

    return (update(timetables)..whereSamePrimaryKey(companion))
        .write(companion);
  }

  Future<void> updateTimetable(
    Timetable timetable, {
    bool showSaturday,
    bool showSunday,
  }) {
    final TimetablesCompanion companion = TimetablesCompanion(
      id: Value<String>(timetable.id),
      saturday: showSaturday != null
          ? Value<bool>(showSaturday)
          : const Value<bool>.absent(),
      sunday: showSunday != null
          ? Value<bool>(showSunday)
          : const Value<bool>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(timetables)..whereSamePrimaryKey(companion))
        .write(companion);
  }

  Future<void> deleteTimetable(Timetable timetable) {
    final TimetablesCompanion companion = TimetablesCompanion(
      id: Value<String>(timetable.id),
    );
    return (delete(timetables)..whereSamePrimaryKey(companion)).go();
  }

  Stream<List<LessonTime>> lessonTimeListStream() {
    return select(lessonTimes).watch().map(
          (List<LessonTimeModel> lessonTimeList) => lessonTimeList
              .map((LessonTimeModel model) => LessonTime.fromDBModel(model))
              .toList(),
        );
  }

  Future<void> addLessonTime(int period, DateTime startTime) {
    return into(lessonTimes).insert(
      LessonTimeModel(
        period: period,
        startTime: startTime,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  Future<void> updateLessonTime(LessonTime lessonTime, DateTime startTime) {
    final LessonTimesCompanion companion = LessonTimesCompanion(
      period: Value<int>(lessonTime.period),
      startTime: Value<DateTime>(startTime),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );

    return (update(lessonTimes)..whereSamePrimaryKey(companion))
        .write(companion);
  }

  Future<void> deleteLessonTime(int period) {
    final LessonTimesCompanion companion = LessonTimesCompanion(
      period: Value<int>(period),
    );

    return (delete(lessonTimes)..whereSamePrimaryKey(companion)).go();
  }

  Future<void> addLesson({
    Subject subject,
    Teacher teacher,
    String room,
    String note,
    int weekday,
    int period,
    Timetable timetable,
  }) {
    return into(lessons).insert(LessonModel(
      id: generateUUID(),
      subjectId: subject.id,
      teacherId: teacher?.id,
      timetableId: timetable.id,
      weekday: weekday,
      period: period,
      note: note,
      room: room,
      lastUpdated: DateTime.now(),
    ));
  }
}
