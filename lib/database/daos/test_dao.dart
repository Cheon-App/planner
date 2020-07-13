// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/database/db_value.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/utils.dart';

part 'test_dao.g.dart';

@UseDao(tables: <Type>[Tests, Subjects, Teachers])
class TestDao extends DatabaseAccessor<Database> with _$TestDaoMixin {
  TestDao(Database db) : super(db);

  JoinedSelectStatement<Table, DataClass> get _testQuery {
    return (select(tests)..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
        .join([
      innerJoin(subjects, subjects.id.equalsExp(tests.subjectId)),
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
    ]);
  }

  Test _rowToTest(TypedResult row) {
    final TestModel test = row.readTable(tests);
    final SubjectModel subject = row.readTable(subjects);
    final TeacherModel teacher = row.readTable(teachers);
    return Test.fromDBModel(
      testModel: test,
      subject: Subject.fromDBModel(
        subjectModel: subject,
        teacher: teacher != null ? Teacher.fromDBModel(teacher) : null,
      ),
    );
  }

  Stream<List<Test>> pastTestListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return (_testQuery
          // All tests that due yesterday or before
          ..where(tests.date.isSmallerThanValue(now)))
        .map(_rowToTest)
        .watch();
  }

  Stream<List<Test>> currentTestListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return (_testQuery // All tests due today or in the future.
          ..where(tests.date.isBiggerOrEqualValue(now)))
        .map(_rowToTest)
        .watch();
  }

  Future<List<Test>> currentTestListFuture() async {
    final DateTime now = strippedDateTime(DateTime.now());

    final List<TypedResult> rows =
        await (_testQuery // All tests due today or in the future.
              ..where(tests.date.isBiggerOrEqualValue(now)))
            .get();

    return rows.map(_rowToTest).toList();
  }

  Future<void> addTest({
    @required Subject subject,
    @required DateTime date,
    @required String name,
    @required String content,
    @required int priority,
  }) {
    return into(tests).insert(
      TestModel(
        id: generateUUID(),
        content: content,
        date: date,
        subjectId: subject.id,
        title: name,
        lastUpdated: DateTime.now(),
        priority: priority,
      ),
    );
  }

  Future<void> updateTest(
    Test test, {
    String name,
    DateTime date,
    String content,
    int priority,
    Subject subject,
  }) {
    final TestsCompanion companion = TestsCompanion(
      id: Value<String>(test.id),
      title: DbValue(name),
      content: DbValue(content),
      date: DbValue(date),
      priority: DbValue(priority),
      subjectId: DbValue(subject?.id),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(tests)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteTest(Test test) {
    return (delete(tests)
          ..whereSamePrimaryKey(TestsCompanion(id: Value<String>(test.id))))
        .go();
  }
}
