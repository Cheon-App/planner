import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';

part 'teacher_dao.g.dart';

@UseDao(tables: <Type>[Teachers])
class TeacherDao extends DatabaseAccessor<Database> with _$TeacherDaoMixin {
  TeacherDao(Database db) : super(db);

  Stream<List<Teacher>> teacherListStream() {
    return select(teachers)
        .map((TeacherModel model) => Teacher.fromDBModel(model))
        .watch();
  }

  Future<void> addTeacher({
    @required String name,
    @required String email,
  }) {
    return into(teachers).insert(TeacherModel(
      id: generateUUID(),
      name: name,
      email: email,
      // deprecated
      yearId: '',
      lastUpdated: DateTime.now(),
    ));
  }

  Future<void> deleteTeacher(Teacher teacher) {
    return (delete(teachers)
          ..whereSamePrimaryKey(
            TeachersCompanion(id: Value<String>(teacher.id)),
          ))
        .go();
  }

  Future<void> updateTeacher(Teacher teacher, {String name, String email}) {
    final TeachersCompanion companion = TeachersCompanion(
      id: Value<String>(teacher.id),
      name: name != null ? Value<String>(name) : const Value<String>.absent(),
      email:
          email != null ? Value<String>(email) : const Value<String>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );

    return (update(teachers)..whereSamePrimaryKey(companion)).write(companion);
  }
}
