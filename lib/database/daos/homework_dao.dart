import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart' as tables;
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/homework.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'homework_dao.g.dart';

@UseDao(tables: <Type>[
  tables.Homework,
  tables.Years,
  tables.Subjects,
  tables.Teachers,
])
class HomeworkDao extends DatabaseAccessor<Database> with _$HomeworkDaoMixin {
  HomeworkDao(Database db) : super(db);

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  JoinedSelectStatement<Table, DataClass> _homeworkQueryFromYearModel(
      YearModel yearModel) {
    return (select(subjects)
          ..where(
            ($SubjectsTable table) => table.yearId.equals(
              uuidToUint8List(yearModel.id),
            ),
          ))
        .join(<Join<Table, DataClass>>[
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
      innerJoin(homework, homework.subjectId.equalsExp(subjects.id)),
    ]);
  }

  List<Homework> _homeworkListFromTypedResult(
    List<TypedResult> rows,
    YearModel yearModel,
  ) {
    return rows.map((TypedResult row) {
      final HomeworkModel homeworkModel = row.readTable(homework);
      final SubjectModel subject = row.readTable(subjects);
      final TeacherModel teacher = row.readTable(teachers);
      return Homework.fromDBModel(
        homeworkModel: homeworkModel,
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

  Stream<List<Homework>> currentHomeworkListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_homeworkQueryFromYearModel(yearModel)
            // Homework that's due in the future or is incomplete
            ..where(
              homework.due.isBiggerOrEqualValue(now) |
                  homework.progress.isSmallerThanValue(1),
            ))
          .watch()
          .map(
            (List<TypedResult> rows) =>
                _homeworkListFromTypedResult(rows, yearModel),
          );
    });
  }

  Stream<List<Homework>> pastHomeworkListStream() {
    final DateTime now = strippedDateTime(DateTime.now());
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_homeworkQueryFromYearModel(yearModel)
            // Homework that's due in the past and complete
            ..where(
              homework.due.isSmallerThanValue(now) &
                  homework.progress.equals(1),
            ))
          .watch()
          .map(
            (List<TypedResult> rows) => _homeworkListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Stream<List<Homework>> dueHomeworkListFromDateStream(DateTime date) {
    final DateTime dueDate = strippedDateTime(date);

    return _activeYearStream().switchMap((YearModel yearModel) {
      return (_homeworkQueryFromYearModel(yearModel)
            // Homework that's due in the past and complete
            ..where(homework.due.equals(dueDate)))
          .watch()
          .map(
            (List<TypedResult> rows) => _homeworkListFromTypedResult(
              rows,
              yearModel,
            ),
          );
    });
  }

  Future<void> addHomework({
    @required String name,
    @required String description,
    @required Subject subject,
    @required DateTime due,
    @required Duration length,
  }) async {
    print('Adding homework: $name');
    await into(homework).insert(
      HomeworkModel(
        id: generateUUID(),
        title: name,
        description: description,
        due: due,
        subjectId: subject.id,
        length: length?.inMinutes,
        lastUpdated: DateTime.now(),
        progress: 0,
        // TODO allow homework to be assigned a lesson
        lessonId: null,
        // TODO allow homework to be assigned a study session
        studyId: null,
      ),
    );
  }

  Future<void> deleteHomework(Homework homework) {
    return (delete(this.homework)
          ..whereSamePrimaryKey(
            HomeworkCompanion(id: Value<String>(homework.id)),
          ))
        .go();
  }

  Future<void> updateHomework(
    Homework homework, {
    double progress,
    String description,
  }) {
    final HomeworkCompanion companion = HomeworkCompanion(
      id: Value<String>(homework.id),
      progress: progress != null
          ? Value<double>(progress)
          : const Value<double>.absent(),
      description: description != null
          ? Value<String>(description)
          : const Value<String>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(this.homework)..whereSamePrimaryKey(companion))
        .write(companion);
  }
}
