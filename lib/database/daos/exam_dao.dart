import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/utils.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'exam_dao.g.dart';

@UseDao(tables: <Type>[Exams, Years, Subjects, Teachers])
class ExamDao extends DatabaseAccessor<Database> with _$ExamDaoMixin {
  ExamDao(Database db) : super(db);

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

  JoinedSelectStatement<Table, DataClass> _examQueryFromYearModel(
      YearModel yearModel) {
    return (select(subjects)
          ..where(
            ($SubjectsTable table) => table.yearId.equals(
              uuidToUint8List(yearModel.id),
            ),
          ))
        .join(<Join<Table, DataClass>>[
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
      innerJoin(exams, exams.subjectId.equalsExp(subjects.id))
    ]);
  }

  List<Exam> _examListFromTypedResult(
    List<TypedResult> rows,
    YearModel yearModel,
  ) {
    return rows.map((TypedResult row) {
      final ExamModel exam = row.readTable(exams);
      final SubjectModel subject = row.readTable(subjects);
      final TeacherModel teacher = row.readTable(teachers);
      return Exam.fromDBModel(
        examModel: exam,
        subject: Subject.fromDBModel(
          subjectModel: subject,
          year: Year.fromDBModel(yearModel),
          teacher: teacher != null
              ? Teacher.fromDBModel(
                  teacherModel: teacher,
                  year: Year.fromDBModel(yearModel),
                )
              : null,
        ),
      );
    }).toList();
  }

  Stream<List<Exam>> pastExamListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_examQueryFromYearModel(yearModel)
            // All exams that started yesterday or before
            ..where(exams.start.isSmallerThanValue(now)))
          .watch()
          .map(
            (List<TypedResult> rows) => _examListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Stream<List<Exam>> currentExamListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_examQueryFromYearModel(yearModel)
            // All exams that start today or after
            ..where(exams.start.isBiggerOrEqualValue(now)))
          .watch()
          .map(
            (List<TypedResult> rows) => _examListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Future<List<Exam>> currentExamListFuture() async {
    final DateTime now = strippedDateTime(DateTime.now());
    final YearModel yearModel = await _activeYearFuture();
    // All exams that start today or after
    final List<TypedResult> rows = await (_examQueryFromYearModel(yearModel)
          ..where(exams.start.isBiggerOrEqualValue(now)))
        .get();

    return _examListFromTypedResult(
      rows,
      yearModel,
    );
  }

  Stream<List<Exam>> examListFromDateStream(DateTime date) {
    final DateTime startDate = strippedDateTime(date);
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_examQueryFromYearModel(yearModel)
            // All exams that start on the provided date
            ..where(
              exams.start.isBetweenValues(
                startDate,
                startDate.add(const Duration(days: 1)),
              ),
            ))
          .watch()
          .map(
            (List<TypedResult> rows) => _examListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Future<void> addExam({
    @required String name,
    @required Subject subject,
    @required DateTime dateTime,
    @required Duration length,
    @required String seat,
    @required String location,
    @required int priority,
  }) async {
    return into(exams).insert(ExamModel(
      id: generateUUID(),
      start: dateTime,
      end: dateTime.add(length),
      subjectId: subject.id,
      title: name,
      location: location,
      seat: seat,
      priority: priority,
      lastUpdated: DateTime.now(),
    ));
  }

  Future<void> updateExam(
    Exam exam, {
    String name,
    DateTime start,
    DateTime end,
    String seat,
    String location,
    int priority,
  }) {
    final ExamsCompanion companion = ExamsCompanion(
      id: Value<String>(exam.id),
      title: name != null ? Value<String>(name) : const Value<String>.absent(),
      start: start != null
          ? Value<DateTime>(start)
          : const Value<DateTime>.absent(),
      end: end != null ? Value<DateTime>(end) : const Value<DateTime>.absent(),
      seat: seat != null ? Value<String>(seat) : const Value<String>.absent(),
      location: location != null
          ? Value<String>(location)
          : const Value<String>.absent(),
      priority:
          priority != null ? Value<int>(priority) : const Value<int>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(exams)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteExam(Exam exam) {
    return (delete(exams)
          ..whereSamePrimaryKey(
            ExamsCompanion(id: Value<String>(exam.id)),
          ))
        .go();
  }
}
