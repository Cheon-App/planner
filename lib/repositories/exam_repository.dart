// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:cheon/database/daos/exam_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/exam.dart';

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
}
