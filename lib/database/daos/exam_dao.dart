// Flutter imports:
import 'package:flutter/material.dart' hide Table;

// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/utils.dart';

part 'exam_dao.g.dart';

@UseDao(tables: <Type>[Exams, Subjects, Teachers])
class ExamDao extends DatabaseAccessor<Database> with _$ExamDaoMixin {
  ExamDao(Database db) : super(db);

  JoinedSelectStatement<Table, DataClass> _examQuery() {
    return (select(exams)..orderBy([(tbl) => OrderingTerm.asc(tbl.start)]))
        .join([
      innerJoin(subjects, subjects.id.equalsExp(exams.subjectId)),
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
    ]);
  }

  List<Exam> _examListFromTypedResult(List<TypedResult> rows) {
    return rows.map((TypedResult row) {
      final ExamModel exam = row.readTable(exams);
      final SubjectModel subject = row.readTable(subjects);
      final TeacherModel teacher = row.readTable(teachers);
      return Exam.fromDBModel(
        examModel: exam,
        subject: Subject.fromDBModel(
          subjectModel: subject,
          teacher: teacher != null ? Teacher.fromDBModel(teacher) : null,
        ),
      );
    }).toList();
  }

  Stream<List<Exam>> pastExamListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return (_examQuery()
          // All exams that started yesterday or before
          ..where(exams.start.isSmallerThanValue(now)))
        .watch()
        .map((List<TypedResult> rows) => _examListFromTypedResult(rows));
  }

  Stream<List<Exam>> currentExamListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return (_examQuery()
          // All exams that start today or after
          ..where(exams.start.isBiggerOrEqualValue(now)))
        .watch()
        .map((List<TypedResult> rows) => _examListFromTypedResult(rows));
  }

  Future<List<Exam>> currentExamListFuture() async {
    final DateTime now = strippedDateTime(DateTime.now());
    // All exams that start today or after
    final List<TypedResult> rows = await (_examQuery()
          ..where(exams.start.isBiggerOrEqualValue(now)))
        .get();

    return _examListFromTypedResult(rows);
  }

  Stream<List<Exam>> examListFromDateStream(DateTime date) {
    final DateTime startDate = strippedDateTime(date);
    return (_examQuery()
          // All exams that start on the provided date
          ..where(
            exams.start.isBetweenValues(
              startDate,
              startDate.add(const Duration(days: 1)),
            ),
          ))
        .watch()
        .map((List<TypedResult> rows) => _examListFromTypedResult(rows));
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
    String examId, {
    String name,
    DateTime start,
    DateTime end,
    String seat,
    String location,
    int priority,
    Subject subject,
  }) {
    final ExamsCompanion companion = ExamsCompanion(
      id: Value<String>(examId),
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
      subjectId: subject == null //
          ? Value<String>.absent()
          : Value<String>(subject.id),
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
