import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'teacher_dao.g.dart';

@UseDao(tables: <Type>[Teachers, Years])
class TeacherDao extends DatabaseAccessor<Database> with _$TeacherDaoMixin {
  TeacherDao(Database db) : super(db);

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  Stream<List<Teacher>> teacherListStream() {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (select(teachers)
            ..where(($TeachersTable table) =>
                table.yearId.equals(uuidToUint8List(yearModel.id))))
          .map(
            (TeacherModel model) => Teacher.fromDBModel(
              teacherModel: model,
              year: Year.fromDBModel(yearModel),
            ),
          )
          .watch();
    });
  }

  Future<void> addTeacher({
    @required String name,
    @required String email,
    @required Year year,
  }) {
    return into(teachers).insert(TeacherModel(
      id: generateUUID(),
      name: name,
      email: email,
      yearId: year.id,
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
