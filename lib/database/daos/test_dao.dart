import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart';
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'test_dao.g.dart';

@UseDao(tables: <Type>[Tests, Years, Subjects, Teachers])
class TestDao extends DatabaseAccessor<Database> with _$TestDaoMixin {
  TestDao(Database db) : super(db);

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  Future<YearModel> _activeYearFuture() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .getSingle();
  }

  JoinedSelectStatement<Table, DataClass> _testQueryFromYearModel(
      YearModel yearModel) {
    return (select(subjects)
          ..where(
            ($SubjectsTable table) => table.yearId.equals(
              uuidToUint8List(yearModel.id),
            ),
          ))
        .join(<Join<Table, DataClass>>[
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
      innerJoin(tests, tests.subjectId.equalsExp(subjects.id)),
    ]);
  }

  List<Test> _testListFromTypedResult(
    List<TypedResult> rows,
    YearModel yearModel,
  ) {
    return rows.map((TypedResult row) {
      final TestModel test = row.readTable(tests);
      final SubjectModel subject = row.readTable(subjects);
      final TeacherModel teacher = row.readTable(teachers);
      return Test.fromDBModel(
        testModel: test,
        subject: Subject.fromDBModel(
          subjectModel: subject,
          year: Year.fromDBModel(yearModel),
          teacher: teacher != null
              ? Teacher.fromDBModel(
                  teacherModel: teacher,
                  year: Year.fromDBModel(yearModel),
                )
              : null,
        ),
      );
    }).toList();
  }

  Stream<List<Test>> pastTestListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_testQueryFromYearModel(yearModel)
            // All tests that due yesterday or before
            ..where(tests.date.isSmallerThanValue(now)))
          .watch()
          .map((List<TypedResult> rows) => _testListFromTypedResult(
                rows,
                yearModel,
              ));
    });
  }

  Stream<List<Test>> currentTestListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_testQueryFromYearModel(
              yearModel) // All tests due today or in the future.
            ..where(tests.date.isBiggerOrEqualValue(now)))
          .watch()
          .map((List<TypedResult> rows) => _testListFromTypedResult(
                rows,
                yearModel,
              ));
    });
  }

  Future<List<Test>> currentTestListFuture() async {
    final YearModel yearModel = await _activeYearFuture();
    final DateTime now = strippedDateTime(DateTime.now());

    final List<TypedResult> rows = await (_testQueryFromYearModel(
            yearModel) // All tests due today or in the future.
          ..where(tests.date.isBiggerOrEqualValue(now)))
        .get();

    return _testListFromTypedResult(
      rows,
      yearModel,
    );
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
  }) {
    final TestsCompanion companion = TestsCompanion(
      id: Value<String>(test.id),
      title: name != null ? Value<String>(name) : const Value<String>.absent(),
      content: content != null
          ? Value<String>(content)
          : const Value<String>.absent(),
      date:
          date != null ? Value<DateTime>(date) : const Value<DateTime>.absent(),
      priority:
          priority != null ? Value<int>(priority) : const Value<int>.absent(),
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
