import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/repositories/lesson_repository.dart';

class LessonsVM {
  final LessonRepository _lessonRepository = LessonRepository.instance;

  Stream<List<Lesson>> get lessonListStream =>
      _lessonRepository.lessonListStream;

  Stream<List<Lesson>> lessonListFromSubjectStream(Subject subject) =>
      _lessonRepository.lessonListFromSubjectStream(subject);

  Future<void> updateLesson(
    Lesson lesson, {
    String room,
    String note,
  }) =>
      _lessonRepository.updateLesson(lesson, room: room, note: note);

  Future<void> deleteLesson(Lesson lessson) =>
      _lessonRepository.deleteLesson(lessson);

  void dispose() {}
}
