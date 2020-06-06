import 'package:cheon/database/daos/exam_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/exam.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:cheon/models/subject.dart' as subject_model;

class ExamRepository {
  ExamRepository._internal() {
    _dao.currentExamListStream().listen(_currentExamListSubject.add);
    _dao.pastExamListStream().listen(_pastExamListSubject.add);
  }
  static ExamRepository get instance => _singleton;
  static final ExamRepository _singleton = ExamRepository._internal();

  final ExamDao _dao = container<Database>().examDao;

  final BehaviorSubject<List<Exam>> _currentExamListSubject =
      BehaviorSubject<List<Exam>>();

  final BehaviorSubject<List<Exam>> _pastExamListSubject =
      BehaviorSubject<List<Exam>>();

  Stream<List<Exam>> get currentExamListStream =>
      _currentExamListSubject.stream;
  Stream<List<Exam>> get pastExamListStream => _pastExamListSubject.stream;

  Stream<List<Exam>> examListFromDateStream(DateTime date) =>
      _dao.examListFromDateStream(date);

  Future<void> addExam({
    @required String name,
    @required subject_model.Subject subject,
    @required DateTime date,
    @required Duration length,
    @required String seat,
    @required String location,
    @required int priority,
  }) async {
    await _dao.addExam(
      name: name,
      subject: subject,
      dateTime: date,
      length: length,
      seat: seat?.isNotEmpty ?? false ? seat : null,
      location: location?.isNotEmpty ?? false ? location : null,
      priority: priority,
    );
    // await App.analytics.logEvent(name: 'add_exam');
  }

  Future<void> updateExam(
    Exam exam, {
    String name,
    DateTime start,
    DateTime end,
    String seat,
    String location,
    int priority,
  }) =>
      _dao.updateExam(
        exam,
        name: name,
        start: start,
        end: end,
        seat: seat,
        location: location,
        priority: priority,
      );

  Future<void> deleteExam(Exam exam) => _dao.deleteExam(exam);
}
