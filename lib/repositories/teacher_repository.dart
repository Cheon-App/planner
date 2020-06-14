// Package imports:
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:cheon/database/daos/teacher_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/teacher.dart';

class TeacherRepository {
  TeacherRepository._internal() {
    _dao.teacherListStream().listen(_teacherListSubject.add);
  }
  static TeacherRepository get instance => _singleton;
  static final TeacherRepository _singleton = TeacherRepository._internal();

  final TeacherDao _dao = container<Database>().teacherDao;

  final BehaviorSubject<List<Teacher>> _teacherListSubject =
      BehaviorSubject<List<Teacher>>();
  Stream<List<Teacher>> get teacherListStream => _teacherListSubject.stream;

  Future<void> addTeacher({@required String name, @required String email}) =>
      _dao.addTeacher(name: name, email: email);

  Future<void> updateTeacher(Teacher teacher, {String name, String email}) =>
      _dao.updateTeacher(teacher, name: name, email: email);

  Future<void> deleteTeacher(Teacher teacher) => _dao.deleteTeacher(teacher);
}
