import 'package:cheon/models/assessment.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/repositories/exam_repository.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/repositories/test_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class ExamsVM {
  final ExamRepository _examRepository = ExamRepository.instance;
  final TestRepository _testRepository = TestRepository.instance;
  final StudyRepository _studyRepository = StudyRepository.instance;

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
    await _testRepository.addTest(
      subject: subject,
      date: date,
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
    await _examRepository.addExam(
      name: name,
      subject: subject,
      date: date,
      length: length,
      seat: seat,
      location: location,
      priority: priority,
    );

    // TODO generate revision blocks
  }

  Future<void> deleteExam(Exam exam) => _examRepository.deleteExam(exam);
  Future<void> deleteTest(Test test) => _testRepository.deleteTest(test);

  Future<void> updateExam(
    Exam exam, {
    String name,
    DateTime start,
    DateTime end,
    String seat,
    String location,
  }) =>
      _examRepository.updateExam(
        exam,
        name: name,
        start: start,
        end: end,
        seat: seat,
        location: location,
      );

  Future<void> updateTest(
    Test test, {
    String name,
    DateTime date,
    String content,
  }) =>
      _testRepository.updateTest(
        test,
        name: name,
        date: date,
        content: content,
      );

  void dispose() {}
}
