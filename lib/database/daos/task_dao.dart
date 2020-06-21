// Package imports:
import 'package:moor/moor.dart';

// Project imports:
import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart' as tables;
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/core/dates/date_utils.dart';

part 'task_dao.g.dart';

@UseDao(tables: <Type>[
  tables.Tasks,
  tables.SubTasks,
  tables.Subjects,
  tables.Teachers,
])
class TaskDao extends DatabaseAccessor<Database> with _$TaskDaoMixin {
  TaskDao(Database db) : super(db);

  JoinedSelectStatement<Table, DataClass> get _taskQuery {
    return select(tasks).join(<Join<Table, DataClass>>[
      leftOuterJoin(subjects, subjects.id.equalsExp(tasks.subjectId)),
      leftOuterJoin(teachers, teachers.id.equalsExp(subjects.teacherId)),
    ]);
  }

  Task _rowToTask(TypedResult row) {
    final taskModel = row.readTable(tasks);
    final subjectModel = row.readTable(subjects);
    final teacherModel = row.readTable(teachers);
    return Task.fromDbModel(
      taskModel,
      subjectModel != null
          ? Subject.fromDBModel(
              subjectModel: subjectModel,
              teacher: teacherModel != null
                  ? Teacher.fromDBModel(teacherModel)
                  : null,
            )
          : null,
    );
  }

  Stream<List<Task>> currentTasksStream() {
    final DateTime now = DateTime.now().truncateToDay();
    return (_taskQuery
          ..where(tasks.completed.equals(false))
          ..where(tasks.due.isBiggerOrEqualValue(now))
          ..orderBy([OrderingTerm.asc(tasks.due)]))
        .map<Task>(_rowToTask)
        .watch();
  }

  Stream<List<Task>> overdueTasksStream() {
    final DateTime now = DateTime.now().truncateToDay();
    return (_taskQuery
          ..where(tasks.completed.equals(false))
          ..where(tasks.due.isSmallerThanValue(now))
          ..orderBy([OrderingTerm.asc(tasks.due)]))
        .map<Task>(_rowToTask)
        .watch();
  }

  Stream<List<Task>> completedTasksStream() {
    return (_taskQuery
          ..where(tasks.completed.equals(true))
          ..orderBy([OrderingTerm.desc(tasks.due)]))
        .map<Task>(_rowToTask)
        .watch();
  }

  // The number of tasks due today
  Stream<int> tasksDue(DateTime date) {
    return Stream.value(0);
    // TODO fix it only returning 0 or 1
    final filter = tasks.due.equals(date.truncateToDay());
    final count = countAll(filter: filter);

    final query = selectOnly(tasks)..addColumns([count]);
    return query.map((row) => row.read(count)).watchSingle();
  }

  // TODO fix this
  Stream<int> tasksToGo(DateTime date) {
    return Stream.value(0);

    date = date.truncateToDay();

    // filter only available from SQLITE v3.3!!!
    final Expression<int> aggregate = tasks.id.count(
      filter: tasks.completed.equals(false) & tasks.due.equals(date),
    );

    final filter = tasks.completed.equals(false) & tasks.due.equals(date);
    final count = countAll(filter: filter);
    final query = selectOnly(tasks)..addColumns([count]);
    return query.map((row) => row.read(count)).watchSingle();

    // final query = selectOnly(tasks)..addColumns([aggregate]);
    // return query.map((row) => row.read(aggregate)).watchSingle();
  }

  Future<void> addTask({
    @required String title,
    @required String note,
    @required DateTime date,
    @required Subject subject,
  }) async {
    await into(tasks).insert(TaskModel(
      id: generateUUID(),
      title: title,
      description: note,
      completed: false,
      due: date,
      subjectId: subject?.id,
      lastUpdated: DateTime.now(),
    ));
  }

  Future<void> deleteTask(Task task) async {
    final companion = TasksCompanion(id: Value<String>(task.id));
    await (delete(tasks)..whereSamePrimaryKey(companion)).go();
  }

  /// *** Always provide the subject if it shouldn't be removed ***
  Future<void> updateTask(
    Task task, {
    @required bool completed,
    @required String title,
    @required String note,
    @required DateTime date,
    @required Subject subject,
  }) async {
    final companion = TasksCompanion(
      id: Value<String>(task.id),
      completed: completed == null //
          ? Value<bool>.absent()
          : Value<bool>(completed),
      due: date == null ? Value<DateTime>.absent() : Value<DateTime>(date),
      description: note == null ? Value<String>.absent() : Value<String>(note),
      title: title == null ? Value<String>.absent() : Value<String>(title),
      lastUpdated: Value<DateTime>(DateTime.now()),
      // Removes a subject if one isn't present
      subjectId: Value<String>(subject?.id),
    );

    await (update(tasks)..whereSamePrimaryKey(companion)).write(companion);
  }
}
