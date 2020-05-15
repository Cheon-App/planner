import 'package:cheon/models/homework.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/repositories/homework_repository.dart';
import 'package:meta/meta.dart';

class HomeworkVM {
  final HomeworkRepository _homeworkRepository = HomeworkRepository.instance;

  /// A stream of homework either due in the future or overdue
  Stream<List<Homework>> get currentHomeworkStream =>
      _homeworkRepository.currentHomeworkListStream;

  /// A stream of homework due in the past including overdue homework
  Stream<List<Homework>> get pastHomeworkStream =>
      _homeworkRepository.pastHomeworkListStream;

  Future<void> addHomework({
    @required String name,
    @required String description,
    @required Subject subject,
    @required DateTime due,
    @required Duration length,
  }) =>
      _homeworkRepository.addHomework(
        name: name,
        description: description,
        subject: subject,
        due: due,
        length: length,
      );

  Future<void> updateHomework(
    Homework homework, {
    double progress,
    String description,
  }) =>
      _homeworkRepository.updateHomework(
        homework,
        progress: progress,
        description: description,
      );

  Future<void> deleteHomework(Homework homework) =>
      _homeworkRepository.deleteHomework(homework);

  void dispose() {}
}
