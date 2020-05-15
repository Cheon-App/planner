import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/models/year.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'lesson_dao.g.dart';

@UseDao(tables: <Type>[
  Lessons,
  Timetables,
  Teachers,
  Subjects,
  Years,
  LessonTimes,
])
class LessonDao extends DatabaseAccessor<Database> with _$LessonDaoMixin {
  LessonDao(Database db) : super(db);

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  Future<YearModel> _activeYearFuture() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .getSingle();
  }

  JoinedSelectStatement<Table, DataClass> _lessonQueryFromYearModel(
      YearModel yearModel) {
    // A lesson can have a different teacher to the default teacher assigned to
    // a subject so to preserve both in a single query we need aliases.
    final $TeachersTable lessonTeacher = alias(teachers, 'lesson_teacher');
    final $TeachersTable subjectTeacher = alias(teachers, 'subject_teacher');
    return (select(timetables)
          ..where(
            ($TimetablesTable table) => table.yearId.equals(
              uuidToUint8List(yearModel.id),
            ),
          ))
        .join(<Join<Table, DataClass>>[
      innerJoin(lessons, lessons.timetableId.equalsExp(timetables.id)),
      innerJoin(lessonTimes, lessonTimes.period.equalsExp(lessons.period)),
      innerJoin(subjects, subjects.id.equalsExp(lessons.subjectId)),
      leftOuterJoin(
        lessonTeacher,
        lessonTeacher.id.equalsExp(lessons.teacherId),
      ),
      leftOuterJoin(
        subjectTeacher,
        subjectTeacher.id.equalsExp(subjects.teacherId),
      ),
    ]);
  }

  List<Lesson> _lessonListFromTypedResult(
    List<TypedResult> rows,
    YearModel yearModel,
  ) {
    final $TeachersTable lessonTeacherAlias = alias(teachers, 'lesson_teacher');
    final $TeachersTable subjectTeacherAlias =
        alias(teachers, 'subject_teacher');
    return rows.map(
      (TypedResult row) {
        final Year year = Year.fromDBModel(yearModel);
        final TimetableModel timetableModel = row.readTable(timetables);

        final LessonModel lessonModel = row.readTable(lessons);

        final LessonTimeModel lessonTimeModel = row.readTable(lessonTimes);
        final DateTime startTime = lessonTimeModel.startTime;

        final SubjectModel subjectModel = row.readTable(subjects);

        final TeacherModel lessonTeacherModel =
            row.readTable(lessonTeacherAlias);
        final Teacher lessonTeacher = lessonTeacherModel != null
            ? Teacher.fromDBModel(
                teacherModel: lessonTeacherModel,
                year: year,
              )
            : null;

        final TeacherModel subjectTeacherModel =
            row.readTable(subjectTeacherAlias);

        final Teacher subjectTeacher = subjectTeacherModel != null
            ? Teacher.fromDBModel(
                teacherModel: subjectTeacherModel,
                year: year,
              )
            : null;

        return Lesson.fromDBModel(
          lessonModel,
          subject: Subject.fromDBModel(
            subjectModel: subjectModel,
            year: year,
            teacher: subjectTeacher,
          ),
          teacher: lessonTeacher,
          timetable: Timetable.fromDBModel(timetableModel, year),
          startTime: startTime,
        );
      },
    ).toList();
  }

  /// a list of lessons that belong to a specific timetable.
  Stream<List<Lesson>> lessonListFromTimetableStream(Timetable timetable) {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_lessonQueryFromYearModel(yearModel)
            ..where(
              timetables.id.equals(uuidToUint8List(timetable.id)),
            ))
          .watch()
          .map(
            (List<TypedResult> rows) => _lessonListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  /// An unfiltered list of lessons
  Stream<List<Lesson>> lessonListStream() {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return _lessonQueryFromYearModel(yearModel).watch().map(
            (List<TypedResult> rows) => _lessonListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Future<List<Lesson>> lessonListFuture() async {
    final YearModel yearModel = await _activeYearFuture();
    final List<TypedResult> rows =
        await _lessonQueryFromYearModel(yearModel).get();

    return _lessonListFromTypedResult(rows, yearModel);
  }

  // Used to show other lessons when viewing a particular lessson.
  Stream<List<Lesson>> lessonListFromSubjectStream(Subject subject) {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_lessonQueryFromYearModel(yearModel)
            ..where(
              subjects.id.equals(uuidToUint8List(subject.id)),
            ))
          .watch()
          .map(
            (List<TypedResult> rows) => _lessonListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Stream<List<Lesson>> lessonListFromDayStream(
      int weekday, Timetable timetable) {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_lessonQueryFromYearModel(yearModel)
            ..where(
              timetables.id.equals(uuidToUint8List(timetable.id)),
            )
            ..where(lessons.weekday.equals(weekday)))
          .watch()
          .map(
            (List<TypedResult> rows) => _lessonListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Future<void> updateLesson(Lesson lesson, {String room, String note}) {
    final LessonsCompanion companion = LessonsCompanion(
      id: Value<String>(lesson.id),
      room: room != null ? Value<String>(room) : const Value<String>.absent(),
      note: note != null ? Value<String>(note) : const Value<String>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(lessons)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteLesson(Lesson lesson) {
    final LessonsCompanion companion = LessonsCompanion(
      id: Value<String>(lesson.id),
    );
    return (delete(lessons)..whereSamePrimaryKey(companion)).go();
  }
}
