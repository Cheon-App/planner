import 'package:cheon/database/daos/test_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/utils.dart';
import 'package:rxdart/rxdart.dart' hide Subject;
import 'package:meta/meta.dart';

class TestRepository {
  TestRepository._internal() {
    _dao.currentTestListStream().listen(_currentTestListSubject.add);
    _dao.pastTestListStream().listen(_pastTestListSubject.add);
  }

  static TestRepository get instance => _singleton;
  static final TestRepository _singleton = TestRepository._internal();

  final TestDao _dao = container<Database>().testDao;

  final BehaviorSubject<List<Test>> _currentTestListSubject =
      BehaviorSubject<List<Test>>();
  final BehaviorSubject<List<Test>> _pastTestListSubject =
      BehaviorSubject<List<Test>>();

  Stream<List<Test>> get currentTestListStream =>
      _currentTestListSubject.stream;
  Stream<List<Test>> get pastTestListStream => _pastTestListSubject.stream;

  Future<void> addTest({
    @required Subject subject,
    @required DateTime date,
    @required String name,
    @required String content,
    @required int priority,
  }) =>
      _dao.addTest(
        name: name,
        date: date != null ? strippedDateTime(date) : null,
        content: content,
        subject: subject,
        priority: priority,
      );

  Future<void> updateTest(
    Test test, {
    String name,
    DateTime date,
    String content,
    int priority,
  }) =>
      _dao.updateTest(
        test,
        name: name,
        date: date != null ? strippedDateTime(date) : null,
        content: content,
      );

  Future<void> deleteTest(Test test) => _dao.deleteTest(test);
}
