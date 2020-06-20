// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

// Project imports:
import 'package:cheon/database/daos/exam_dao.dart';
import 'package:cheon/database/daos/test_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/assessment.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/utils/date_utils.dart';
import 'package:cheon/repositories/exam_repository.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/repositories/test_repository.dart';

class ExamsVM {
  final ExamRepository _examRepository = ExamRepository.instance;
  final TestRepository _testRepository = TestRepository.instance;
  final StudyRepository _studyRepository = StudyRepository.instance;
  final ExamDao _examDao = container<Database>().examDao;
  final TestDao _testDao = container<Database>().testDao;

  // Exams and tests today and after
  Stream<List<Assessment>> get currentAssessmentListStream {
    return CombineLatestStream.combine2(
      _examRepository.currentExamListStream,
      _testRepository.currentTestListStream,
      (List<Exam> examList, List<Test> testList) => <Assessment>[
        ...examList,
        ...testList,
      ],
    );
  }

  // Exams and tests before today
  Stream<List<Assessment>> get pastAssessmentListStream {
    return CombineLatestStream.combine2(
      _examRepository.pastExamListStream,
      _testRepository.pastTestListStream,
      (List<Exam> examList, List<Test> testList) => <Assessment>[
        ...examList,
        ...testList,
      ],
    );
  }

  Stream<List<StudySession>> studySessionListFromExam(Exam exam) =>
      _studyRepository.studySessionListFromExam(exam);

  Stream<List<StudySession>> studySessionListFromTest(Test test) =>
      _studyRepository.studySessionListFromTest(test);

  Future<void> addTest({
    @required Subject subject,
    @required DateTime date,
    @required String name,
    @required String content,
    @required int priority,
  }) async {
    await _testDao.addTest(
      subject: subject,
      date: date != null ? date.truncateToDay() : null,
      name: name,
      content: content,
      priority: priority,
    );
    // TODO generate revision blocks
  }

  Future<void> addExam({
    @required String name,
    @required Subject subject,
    @required DateTime date,
    @required Duration length,
    @required String seat,
    @required String location,
    @required int priority,
  }) async {
    await _examDao.addExam(
      name: name,
      subject: subject,
      dateTime: date,
      length: length,
      seat: seat?.isNotEmpty ?? false ? seat : null,
      location: location?.isNotEmpty ?? false ? location : null,
      priority: priority,
    );

    // TODO generate revision blocks
  }

  Future<void> deleteExam(Exam exam) => _examDao.deleteExam(exam);
  Future<void> deleteTest(Test test) => _testDao.deleteTest(test);

  Future<void> updateExam(
    String examId, {
    String name,
    DateTime start,
    DateTime end,
    String seat,
    String location,
    Subject subject,
    int priority,
  }) {
    return _examDao.updateExam(
      examId,
      name: name,
      start: start,
      end: end,
      seat: seat,
      location: location,
      subject: subject,
      priority: priority,
    );
  }

  Future<void> updateTest(
    Test test, {
    String name,
    DateTime date,
    String content,
    int priority,
    Subject subject,
  }) {
    return _testDao.updateTest(
      test,
      name: name,
      date: date != null ? date.truncateToDay() : null,
      content: content,
      priority: priority,
      subject: subject,
    );
  }

  void dispose() {}
}
