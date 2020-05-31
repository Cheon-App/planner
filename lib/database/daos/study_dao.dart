import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
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

  JoinedSelectStatement<Table, DataClass> get _studySessionQuery {
    final $StudyingTable examStudySession = alias(studying, 'exam_session');
    final $StudyingTable testStudySession = alias(studying, 'test_session');
    return select(subjects).join(<Join<Table, DataClass>>[
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
      leftOuterJoin(exams, exams.subjectId.equalsExp(subjects.id)),
      leftOuterJoin(tests, tests.subjectId.equalsExp(subjects.id)),
      leftOuterJoin(
        examStudySession,
        examStudySession.examId.equalsExp(exams.id),
      ),
      leftOuterJoin(
        testStudySession,
        testStudySession.testId.equalsExp(tests.id),
      )
    ]);
  }

  StudySession _rowToStudySession(TypedResult row) {
    final $StudyingTable examStudySession = alias(studying, 'exam_session');
    final $StudyingTable testStudySession = alias(studying, 'test_session');
    final SubjectModel subjectModel = row.readTable(subjects);
    final TeacherModel teacherModel = row.readTable(teachers);
    final ExamModel examModel = row.readTable(exams);
    final TestModel testModel = row.readTable(tests);
    final StudyModel studyModel =
        row.readTable(examStudySession) ?? row.readTable(testStudySession);

    final Subject subject = Subject.fromDBModel(
      subjectModel: subjectModel,
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

  Stream<List<StudySession>> studySessionListFromDateStream(DateTime date) {
    final DateTime startDate = strippedDateTime(date);

    final $StudyingTable examStudySession = alias(studying, 'exam_session');
    final $StudyingTable testStudySession = alias(studying, 'test_session');

    return (_studySessionQuery
          ..where(examStudySession.start.isBiggerOrEqualValue(startDate) |
              testStudySession.start.isBiggerOrEqualValue(startDate))
          ..where(
            examStudySession.start.isSmallerThanValue(startDate.add(
                  const Duration(days: 1),
                )) |
                testStudySession.start.isSmallerThanValue(
                  startDate.add(const Duration(days: 1)),
                ),
          ))
        .map(_rowToStudySession)
        .watch();
  }

  Stream<List<StudySession>> studySessionListFromExam(Exam exam) {
    final $StudyingTable examStudySession = alias(studying, 'exam_session');
    return (_studySessionQuery
          ..where(examStudySession.examId.equals(uuidToUint8List(exam.id))))
        .map(_rowToStudySession)
        .watch();
  }

  Stream<List<StudySession>> studySessionListFromTest(Test test) {
    final $StudyingTable testStudySession = alias(studying, 'test_session');
    return (_studySessionQuery
          ..where(testStudySession.testId.equals(uuidToUint8List(test.id))))
        .map(_rowToStudySession)
        .watch();
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

  Future<void> addSessionList(List<Session> sessionList) {
    return transaction(() async {
      for (Session session in sessionList) {
        print('Inserting session: ${session.assessmentID}');
        await into(studying).insert(StudyModel(
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
        ));
      }
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
