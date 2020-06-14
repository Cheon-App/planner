// Project imports:
import 'package:cheon/database/daos/lesson_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/repositories/lesson_repository.dart';

class LessonsVM {
  final LessonRepository _lessonRepository = LessonRepository.instance;
  final LessonDao _dao = container<Database>().lessonDao;

  Stream<List<Lesson>> get lessonListStream =>
      _lessonRepository.lessonListStream;

  Stream<List<Lesson>> lessonListFromSubjectStream(Subject subject) =>
      _dao.lessonListFromSubjectStream(subject);

  Future<void> updateLesson(
    Lesson lesson, {
    String room,
    String note,
    Teacher teacher,
    Subject subject,
  }) {
    return _dao.updateLesson(
      lesson,
      note: note,
      room: room,
      subject: subject,
      teacher: teacher,
    );
  }

  Future<void> deleteLesson(Lesson lessson) => _dao.deleteLesson(lessson);

  void dispose() {}
}
