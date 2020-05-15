import 'package:cheon/database/daos/homework_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/homework.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class HomeworkRepository {
  HomeworkRepository._internal() {
    _dao.currentHomeworkListStream().listen(_currentHomeworkListSubject.add);
    _dao.pastHomeworkListStream().listen(_pastHomeworkListSubject.add);
  }
  static HomeworkRepository get instance => _singleton;

  static final HomeworkRepository _singleton = HomeworkRepository._internal();

  final HomeworkDao _dao = Database.instance.homeworkDao;

  final BehaviorSubject<List<Homework>> _currentHomeworkListSubject =
      BehaviorSubject<List<Homework>>();
  final BehaviorSubject<List<Homework>> _pastHomeworkListSubject =
      BehaviorSubject<List<Homework>>();

  Stream<List<Homework>> get currentHomeworkListStream =>
      _currentHomeworkListSubject.stream;

  Stream<List<Homework>> get pastHomeworkListStream =>
      _pastHomeworkListSubject.stream;

  Stream<List<Homework>> dueHomeworkListFromDateStream(DateTime date) =>
      _dao.dueHomeworkListFromDateStream(date);

  Future<void> addHomework({
    @required String name,
    @required String description,
    @required Subject subject,
    @required DateTime due,
    @required Duration length,
  }) =>
      _dao.addHomework(
        name: name,
        description: description,
        subject: subject,
        due: strippedDateTime(due),
        length: length,
      );

  Future<void> updateHomework(
    Homework homework, {
    double progress,
    String description,
  }) =>
      _dao.updateHomework(
        homework,
        progress: progress,
        description: description,
      );

  Future<void> deleteHomework(Homework homework) =>
      _dao.deleteHomework(homework);
}
