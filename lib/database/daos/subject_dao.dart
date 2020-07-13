// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/utils.dart';

part 'subject_dao.g.dart';

@UseDao(tables: <Type>[Subjects, Teachers])
class SubjectDao extends DatabaseAccessor<Database> with _$SubjectDaoMixin {
  SubjectDao(Database db) : super(db);

  Stream<List<Subject>> subjectListStream() {
    final JoinedSelectStatement<Table, DataClass> query = select(subjects)
        .join(<Join<Table, DataClass>>[
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId))
    ]);
    return query.watch().map((List<TypedResult> rows) {
      return rows.map((TypedResult row) {
        final SubjectModel subject = row.readTable(subjects);
        final TeacherModel teacher = row.readTable(teachers);
        return Subject.fromDBModel(
          subjectModel: subject,
          teacher: teacher != null ? Teacher.fromDBModel(teacher) : null,
        );
      }).toList();
    });
  }

  Future<void> addSubject({
    @required String name,
    @required Color color,
    @required String iconId,
    String room,
    Teacher teacher,
  }) async {
    final SubjectModel subject = SubjectModel(
      id: generateUUID(),
      color: color,
      iconId: iconId,
      name: name,
      // deprecated
      yearId: '',
      room: room,
      teacherId: teacher?.id,
      lastUpdated: DateTime.now(),
    );

    await into(subjects).insert(subject);
  }

  Future<void> updateSubject(
    Subject subject, {
    String name,
    Color color,
    String iconId,
    Teacher teacher,
    String room,
  }) {
    final SubjectsCompanion companion = SubjectsCompanion(
      id: Value<String>(subject.id),
      color: color != null ? Value<Color>(color) : const Value<Color>.absent(),
      iconId:
          iconId != null ? Value<String>(iconId) : const Value<String>.absent(),
      name: name != null ? Value<String>(name) : const Value<String>.absent(),
      room: room != null ? Value<String>(room) : const Value<String>.absent(),
      teacherId: teacher != null
          ? Value<String>(teacher.id)
          : const Value<String>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(subjects)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteSubject(Subject subject) {
    final SubjectsCompanion companion =
        SubjectsCompanion(id: Value<String>(subject.id));
    return (delete(subjects)..whereSamePrimaryKey(companion)).go();
  }
}
