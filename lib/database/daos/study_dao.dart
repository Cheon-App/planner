// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/repositories/study_repository.dart';

part 'study_dao.g.dart';

@UseDao(tables: <Type>[
  Exams,
  Tests,
  Subjects,
  Teachers,
  Studying,
])
class StudyDao extends DatabaseAccessor<Database> with _$StudyDaoMixin {
  StudyDao(Database db) : super(db);

  JoinedSelectStatement<Table, DataClass> _studySessionDateQuery(
    DateTime date,
  ) {
    final DateTime startDate = date.truncateToDay();
    final DateTime dayAfterStartDate = startDate.add(Duration(days: 1));

    final $SubjectsTable examSubject = alias(subjects, 'exam_subject');
    final $SubjectsTable testSubject = alias(subjects, 'test_subject');
    final $TeachersTable examTeacher = alias(teachers, 'exam_teacher');
    final $TeachersTable testTeacher = alias(teachers, 'test_teacher');

    return (select(studying)
          ..where(
            (tbl) => tbl.start.isBetweenValues(startDate, dayAfterStartDate),
          ))
        .join(<Join<Table, DataClass>>[
      leftOuterJoin(exams, exams.id.equalsExp(studying.examId)),
      leftOuterJoin(tests, tests.id.equalsExp(studying.testId)),
      leftOuterJoin(examSubject, examSubject.id.equalsExp(exams.subjectId)),
      leftOuterJoin(testSubject, testSubject.id.equalsExp(tests.subjectId)),
      leftOuterJoin(
          examTeacher, examTeacher.id.equalsExp(examSubject.teacherId)),
      leftOuterJoin(
          testTeacher, testTeacher.id.equalsExp(testSubject.teacherId)),
    ]);
  }

  JoinedSelectStatement<Table, DataClass> _studySessionExamQuery(Exam exam) {
    return (select(studying)
          ..where((tbl) => tbl.examId.equals(uuidToUint8List(exam.id))))
        .join(<Join<Table, DataClass>>[
      innerJoin(exams, exams.id.equals(uuidToUint8List(exam.id))),
      innerJoin(subjects, subjects.id.equalsExp(exams.subjectId)),
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
    ]);
  }

  JoinedSelectStatement<Table, DataClass> _studySessionTestQuery(Test test) {
    return (select(studying)
          ..where((tbl) => tbl.testId.equals(uuidToUint8List(test.id))))
        .join(<Join<Table, DataClass>>[
      innerJoin(tests, tests.id.equals(uuidToUint8List(test.id))),
      innerJoin(subjects, subjects.id.equalsExp(tests.subjectId)),
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
    ]);
  }

  StudySession _dateRowToStudySession(TypedResult row) {
    final $SubjectsTable examSubject = alias(subjects, 'exam_subject');
    final $SubjectsTable testSubject = alias(subjects, 'test_subject');

    final $TeachersTable examTeacher = alias(teachers, 'exam_teacher');
    final $TeachersTable testTeacher = alias(teachers, 'test_teacher');

    final SubjectModel examSubjectModel = row.readTable(examSubject);
    final SubjectModel testSubjectModel = row.readTable(testSubject);
    final TeacherModel teacherModel =
        row.readTable(examTeacher) ?? row.readTable(testTeacher);
    final ExamModel examModel = row.readTable(exams);
    final TestModel testModel = row.readTable(tests);
    final StudyModel studyModel = row.readTable(studying);

    final Subject subject = Subject.fromDBModel(
      subjectModel: examSubjectModel ?? testSubjectModel,
      teacher: teacherModel != null ? Teacher.fromDBModel(teacherModel) : null,
    );

    return StudySession.fromDBModel(
      studyModel,
      exam: examModel != null
          ? Exam.fromDBModel(examModel: examModel, subject: subject)
          : null,
      test: testModel != null
          ? Test.fromDBModel(testModel: testModel, subject: subject)
          : null,
    );
  }

  StudySession _examRowToStudySession(TypedResult row) {
    final SubjectModel subjectModel = row.readTable(subjects);
    final TeacherModel teacherModel = row.readTable(teachers);
    final ExamModel examModel = row.readTable(exams);
    final StudyModel studyModel = row.readTable(studying);

    final Subject subject = Subject.fromDBModel(
      subjectModel: subjectModel,
      teacher: teacherModel != null ? Teacher.fromDBModel(teacherModel) : null,
    );

    return StudySession.fromDBModel(
      studyModel,
      exam: Exam.fromDBModel(examModel: examModel, subject: subject),
      test: null,
    );
  }

  StudySession _testRowToStudySession(TypedResult row) {
    final SubjectModel subjectModel = row.readTable(subjects);
    final TeacherModel teacherModel = row.readTable(teachers);
    final TestModel testModel = row.readTable(tests);
    final StudyModel studyModel = row.readTable(studying);

    final Subject subject = Subject.fromDBModel(
      subjectModel: subjectModel,
      teacher: teacherModel != null ? Teacher.fromDBModel(teacherModel) : null,
    );

    return StudySession.fromDBModel(
      studyModel,
      test: Test.fromDBModel(testModel: testModel, subject: subject),
      exam: null,
    );
  }

  Stream<List<StudySession>> studySessionListFromDateStream(DateTime date) {
    return _studySessionDateQuery(date).map(_dateRowToStudySession).watch();
  }

  Stream<List<StudySession>> studySessionListFromExam(Exam exam) {
    return _studySessionExamQuery(exam).map(_examRowToStudySession).watch();
  }

  Stream<List<StudySession>> studySessionListFromTest(Test test) {
    return _studySessionTestQuery(test).map(_testRowToStudySession).watch();
  }

  Stream<double> progressTodayStream() {
    // TODO calculate real value
    return Stream<double>.value(0);
  }

  Stream<int> sessionsCompletedStream() {
    // TODO calculate real value
    return Stream<int>.value(1);
  }

  Stream<int> completionRateStream() {
    // TODO calculate real value
    return Stream<int>.value(2);
  }

  Stream<int> dailyStreakStream() {
    // TODO calculate real value
    return Stream<int>.value(3);
  }

  Stream<int> sesionsToGo(DateTime date) {
    // TODO calculate real value
    return Stream<int>.value(99);
  }

  Future<void> addSessionList(List<Session> sessionList) async {
    return batch((Batch batch) {
      batch.insertAll(
        studying,
        sessionList.map((session) {
          return StudyModel(
            id: generateUUID(),
            examId: session.assessmentType == AssessmentType.EXAM
                ? session.assessmentID
                : null,
            testId: session.assessmentType == AssessmentType.TEST
                ? session.assessmentID
                : null,
            start: session.start,
            end: session.end,
            completed: false,
            lastUpdated: DateTime.now(),
            // Deprecated column
            title: '',
          );
        }).toList(),
      );
    });
  }

  Future<void> removeFutureStudySessions() async {
    final DateTime now = DateTime.now();
    await (delete(studying)
          ..where(
            ($StudyingTable table) => table.start.isBiggerOrEqualValue(now),
          ))
        .go();
  }

  Future<void> updateStudySession(StudySession session,
      {@required bool completed}) async {
    final StudyingCompanion studyingCompanion = StudyingCompanion(
      id: Value<String>(session.id),
      completed: completed != null
          ? Value<bool>(completed)
          : const Value<bool>.absent(),
    );

    await (update(studying)..whereSamePrimaryKey(studyingCompanion))
        .write(studyingCompanion);
  }

  Future<void> deleteStudySession(StudySession session) async {
    final StudyingCompanion studyingCompanion = StudyingCompanion(
      id: Value<String>(session.id),
    );
    await (delete(studying)..whereSamePrimaryKey(studyingCompanion)).go();
  }
}
