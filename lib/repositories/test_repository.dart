// Package imports:
import 'package:rxdart/rxdart.dart' hide Subject;

// Project imports:
import 'package:cheon/database/daos/test_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/test.dart';

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
}
