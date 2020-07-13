// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/database/db_value.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable.dart';

part 'lesson_dao.g.dart';

@UseDao(tables: <Type>[
  Lessons,
  Timetables,
  Teachers,
  Subjects,
  LessonTimes,
])
class LessonDao extends DatabaseAccessor<Database> with _$LessonDaoMixin {
  LessonDao(Database db) : super(db);

  JoinedSelectStatement<Table, DataClass> get _lessonQuery {
    // A lesson can have a different teacher to the default teacher assigned to
    // a subject so to preserve both in a single query we need aliases.
    final $TeachersTable lessonTeacher = alias(teachers, 'lesson_teacher');
    final $TeachersTable subjectTeacher = alias(teachers, 'subject_teacher');
    return select(timetables).join(
      <Join<Table, DataClass>>[
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
      ],
    );
  }

  Lesson _rowToLesson(TypedResult row) {
    final $TeachersTable lessonTeacherAlias = alias(teachers, 'lesson_teacher');
    final $TeachersTable subjectTeacherAlias =
        alias(teachers, 'subject_teacher');
    final TimetableModel timetableModel = row.readTable(timetables);

    final LessonModel lessonModel = row.readTable(lessons);

    final LessonTimeModel lessonTimeModel = row.readTable(lessonTimes);
    final DateTime startTime = lessonTimeModel.startTime;

    final SubjectModel subjectModel = row.readTable(subjects);

    final TeacherModel lessonTeacherModel = row.readTable(lessonTeacherAlias);
    final Teacher lessonTeacher = lessonTeacherModel != null
        ? Teacher.fromDBModel(lessonTeacherModel)
        : null;

    final TeacherModel subjectTeacherModel = row.readTable(subjectTeacherAlias);

    final Teacher subjectTeacher = subjectTeacherModel != null
        ? Teacher.fromDBModel(subjectTeacherModel)
        : null;

    return Lesson.fromDBModel(
      lessonModel,
      subject: Subject.fromDBModel(
        subjectModel: subjectModel,
        teacher: subjectTeacher,
      ),
      teacher: lessonTeacher,
      timetable: Timetable.fromDBModel(timetableModel),
      startTime: startTime,
    );
  }

  /// a list of lessons that belong to a specific timetable.
  Stream<List<Lesson>> lessonListFromTimetableStream(Timetable timetable) {
    return (_lessonQuery
          ..where(
            timetables.id.equals(uuidToUint8List(timetable.id)),
          ))
        .map(_rowToLesson)
        .watch();
  }

  /// An unfiltered list of lessons
  Stream<List<Lesson>> lessonListStream() =>
      _lessonQuery.map(_rowToLesson).watch();

  Future<List<Lesson>> lessonListFuture() async {
    final List<TypedResult> rows = await _lessonQuery.get();

    return rows.map(_rowToLesson).toList();
  }

  // Used to show other lessons when viewing a particular lessson.
  Stream<List<Lesson>> lessonListFromSubjectStream(Subject subject) {
    return (_lessonQuery
          ..where(subjects.id.equals(uuidToUint8List(subject.id))))
        .map(_rowToLesson)
        .watch();
  }

  Stream<List<Lesson>> lessonListFromDayStream(
    int weekday,
    Timetable timetable,
  ) {
    return (_lessonQuery
          ..where(timetables.id.equals(uuidToUint8List(timetable.id)))
          ..where(lessons.weekday.equals(weekday)))
        .map(_rowToLesson)
        .watch();
  }

  Future<void> updateLesson(
    Lesson lesson, {
    String room,
    String note,
    Subject subject,
    Teacher teacher,
  }) {
    final LessonsCompanion companion = LessonsCompanion(
      id: Value<String>(lesson.id),
      room: DbValue(room),
      note: DbValue(note),
      subjectId: DbValue(subject?.id),
      teacherId: DbValue(teacher?.id),
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
