import 'package:cheon/models/teacher.dart';
import 'package:cheon/repositories/teacher_repository.dart';
import 'package:meta/meta.dart';

class TeachersVM {
  final TeacherRepository _teacherRepository = TeacherRepository.instance;

  /// A stream providing a list of teachers
  Stream<List<Teacher>> get teacherListStream =>
      _teacherRepository.teacherListStream;

  /// Creates a teacher
  Future<void> addTeacher({
    @required String name,
    @required String email,
  }) =>
      _teacherRepository.addTeacher(name: name, email: email);

  /// Deletes a teacher
  Future<void> deleteTeacher(Teacher teacher) =>
      _teacherRepository.deleteTeacher(teacher);

  /// Updates details of a teacher
  Future<void> updateTeacher(Teacher teacher, {String name, String email}) =>
      _teacherRepository.updateTeacher(teacher, name: name, email: email);

  void dispose() {}
}
