// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/pages/tasks/view_task_page.dart';
import 'package:cheon/view_models/task_view_model.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/menu_button.dart';
import 'package:cheon/widgets/subject_card.dart';

class TasksPage extends StatefulWidget {
  /// Creates a page containing a list of homework and other tasks
  const TasksPage({Key key}) : super(key: key);

  static const String routeName = '/tasks';

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  Widget counter({@required int count, @required Color color}) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: color,
      ),
      alignment: Alignment.center,
      child: FittedBox(
        child: Text('$count', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final taskVM = context.watch<TaskVM>();
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Tasks'),
          leading: MenuButton(),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('CURRENT'),
                    counter(
                      count: taskVM.currentTasksCount,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('OVERDUE'),
                    counter(
                      count: taskVM.overdueTasksCount,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
              Tab(text: 'COMPLETE'),
            ],
          ),
        ),
        body: TabBarView(
          children: TaskStatus.values
              .map((status) => _TaskList(taskStatus: status))
              .toList(),
        ),
      ),
    );
  }
}

/* class _HomeworkCard extends StatelessWidget {
  const _HomeworkCard({Key key, @required this.homework}) : super(key: key);

  final Homework homework;

  void openHomework(BuildContext context) {
    Navigator.pushNamed(
      context,
      ViewHomeworkPage.routeName,
      arguments: homework,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      color: homework.subject.color,
      title: homework.title,
      trailing: '${dateTimeToDayMonth(homework.due)}',
      subtitle: '${homework.subject.name}',
      onTap: () => openHomework(context),
      bottom: homework.length != Duration.zero
          ? LinearProgressBar(
              key: ValueKey<String>(homework.id),
              color: homework.subject.color,
              fraction: homework.progress,
            )
          : null,
    );
  }
} */

/* class _HomeworkList extends StatefulWidget {
  const _HomeworkList({Key key, @required this.showCurrent}) : super(key: key);
  final bool showCurrent;

  @override
  HomeworkListState createState() => HomeworkListState();
}

@visibleForTesting
class HomeworkListState extends State<_HomeworkList>
    with AutomaticKeepAliveClientMixin {
  @visibleForTesting
  DateTime now = strippedDateTime(DateTime.now());

  @override
  bool get wantKeepAlive => true;

  // TODO abstract this logic to filter dates & use it for assessments

  /// Returns a [DateTime] matching the start of the week i.e. 00:00 on Monday.
  DateTime startOfWeek(DateTime dateTime) =>
      strippedDateTime(dateTime).subtract(Duration(days: dateTime.weekday - 1));

  /// Returns a list of incomplete homework that are also due in the past.
  List<Homework> overdueHomework(List<Homework> all) =>
      all.where((Homework a) => !a.complete() && a.due.isBefore(now)).toList();

  /// Returns a list of homework due today.
  List<Homework> homeworkToday(List<Homework> all) =>
      all.where((Homework a) => strippedDateTime(a.due) == now).toList();

  /// Returns a list of homework due tomorrow.
  List<Homework> homeworkTomorrow(List<Homework> all) => all
      .where((Homework a) => strippedDateTime(a.due)
          .isAtSameMomentAs(now.add(const Duration(days: 1))))
      .toList();

  /// Returns a list of homework due this week excluding homework due
  /// today or tomorrow
  List<Homework> homeworkThisWeek(List<Homework> all) {
    final DateTime weekStart = startOfWeek(now);
    final DateTime weekEnd = weekStart.add(const Duration(days: 7));

    return all.where(
      (Homework a) {
        return (a.due.isAfter(now.add(const Duration(days: 2))) ||
                a.due.isAtSameMomentAs(now.add(const Duration(days: 2)))) &&
            strippedDateTime(a.due).isBefore(weekEnd);
      },
    ).toList();
  }

  /// Returns a list of homework due next week excluding homework due today and
  ///  tomorrow
  List<Homework> homeworkNextWeek(List<Homework> all) {
    // final bool isSaturday = now.weekday == DateTime.saturday;
    final bool isSunday = now.weekday == DateTime.sunday;
    final DateTime nextWeekStart = startOfWeek(now).add(
      const Duration(days: 7),
    );

    final DateTime nextWeekEnd = nextWeekStart.add(const Duration(days: 7));
    return all
        .where(
          (Homework a) =>
              (a.due.isAfter(
                    nextWeekStart.add(Duration(days: isSunday ? 1 : 0)),
                  ) ||
                  a.due.isAtSameMomentAs(
                    nextWeekStart.add(Duration(days: isSunday ? 1 : 0)),
                  )) &&
              a.due.isBefore(nextWeekEnd),
        )
        .toList();
  }

  /// Returns a list of homework that are not due this week or next week.
  List<Homework> otherHomework(List<Homework> all) {
    final DateTime nextWeekEnd = now
        .add(Duration(days: DateTime.sunday - now.weekday + 1))
        .add(const Duration(days: 7));
    return all
        .where((Homework a) =>
            a.due.isAfter(nextWeekEnd) || a.due.isAtSameMomentAs(nextWeekEnd))
        .toList();
  }

  List<Widget> _homeworkCardFromList(List<Homework> homeworkList) {
    homeworkList.sort((Homework a, Homework b) => a.due.compareTo(b.due));
    return homeworkList
        .map((Homework homework) => _HomeworkCard(homework: homework))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Stream<List<Homework>> currentHomeworkStream =
        context.select<TaskVM, Stream<List<Homework>>>(
            (TaskVM vm) => vm.currentHomeworkStream);
    final Stream<List<Homework>> pastHomeworkStream =
        context.select<TaskVM, Stream<List<Homework>>>(
            (TaskVM vm) => vm.pastHomeworkStream);

    return StreamBuilder<List<Homework>>(
      stream: widget.showCurrent ? currentHomeworkStream : pastHomeworkStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Homework>> snapshot,
      ) {
        const EdgeInsetsGeometry scrollablePadding =
            EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 84);
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            if (widget.showCurrent) {
              final List<Homework> overdueHomeworkList =
                  overdueHomework(snapshot.data);
              final List<Homework> homeworkTodayList =
                  homeworkToday(snapshot.data);
              final List<Homework> homeworkTomorrowList =
                  homeworkTomorrow(snapshot.data);
              final List<Homework> homeworkThisWeekList =
                  homeworkThisWeek(snapshot.data);
              final List<Homework> homeworkNextWeekList =
                  homeworkNextWeek(snapshot.data);
              final List<Homework> otherHomeworkList =
                  otherHomework(snapshot.data);
              return ListView(
                primary: false,
                padding: scrollablePadding,
                children: <Widget>[
                  if (overdueHomeworkList.isNotEmpty)
                    StickySection(
                      name: 'Overdue',
                      warning: true,
                      children: _homeworkCardFromList(overdueHomeworkList),
                    ),
                  if (homeworkTodayList.isNotEmpty)
                    StickySection(
                      name: 'Today',
                      children: _homeworkCardFromList(homeworkTodayList),
                    ),
                  if (homeworkTomorrowList.isNotEmpty)
                    StickySection(
                      name: 'Tomorrow',
                      children: _homeworkCardFromList(homeworkTomorrowList),
                    ),
                  if (homeworkThisWeekList.isNotEmpty)
                    StickySection(
                      name: 'This Week',
                      children: _homeworkCardFromList(homeworkThisWeekList),
                    ),
                  if (homeworkNextWeekList.isNotEmpty)
                    StickySection(
                      name: 'Next Week',
                      children: _homeworkCardFromList(homeworkNextWeekList),
                    ),
                  if (otherHomeworkList.isNotEmpty)
                    StickySection(
                      name: 'Other Homework',
                      children: _homeworkCardFromList(otherHomeworkList),
                    ),
                ],
              );
            } else {
              return ListView(
                primary: false,
                padding: scrollablePadding,
                children: <Widget>[
                  StickySection(
                    name: 'Past Homework',
                    children: _homeworkCardFromList(snapshot.data),
                  )
                ],
              );
            }
          } else {
            return EmptyPlaceholder(
              svgPath: IMG_TASKS,
              text:
                  widget.showCurrent ? 'No homework due.' : 'No past homework',
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        return const ErrorMessage();
      },
    );
  }
} */

/* class _ToDoSheet extends StatefulWidget {
  const _ToDoSheet({Key key, @required this.toDo}) : super(key: key);
  final Task toDo;

  @override
  __ToDoSheetState createState() => __ToDoSheetState();
}

class __ToDoSheetState extends State<_ToDoSheet> {
  TextEditingController _titleController;
  TextEditingController _noteController;
  DateTime _date;
  @override
  void initState() {
    super.initState();
    _date = widget.toDo.due;
    _titleController = TextEditingController(text: widget.toDo.title);
    _noteController = TextEditingController(text: widget.toDo.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final TaskVM taskVM = context.watch<TaskVM>();
    return Container(
      height: screenHeight - MediaQuery.of(context).viewInsets.top,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //  completed, date,
            /* Text(
                  widget.toDo.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ), */
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              style: TextStyle(fontWeight: FontWeight.w600),
              onChanged: (String title) => taskVM.updateToDo(
                widget.toDo,
                title: title,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                alignLabelWithHint: true,
              ),
              onChanged: (String note) => taskVM.updateToDo(
                widget.toDo,
                note: note,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: Text('Date'),
                trailing: Text(
                  MaterialLocalizations.of(context).formatFullDate(
                    _date,
                  ),
                ),
                onTap: () {
                  showPlatformDatePicker(
                    context: context,
                    initialDate: widget.toDo.due,
                  ).listen((DateTime date) {
                    if (date == null) return;
                    setState(() => _date = date);
                    taskVM.updateToDo(widget.toDo, date: date);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} */

class _TaskCard extends StatelessWidget {
  const _TaskCard({Key key, @required this.task}) : super(key: key);
  final Task task;

  void _openTask(BuildContext context) => Navigator.pushNamed(
        context,
        ViewTaskPage.routeName,
        arguments: task,
      );

  @override
  Widget build(BuildContext context) {
    final TaskVM vm = context.watch<TaskVM>();
    final hasSubject = task.subject != null;

    final checkBox = Checkbox(
      value: task.completed,
      onChanged: (_) => vm.completeTask(task),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final dateString = MaterialLocalizations.of(context).formatShortMonthDay(
      task.due,
    );

    final hasDescription = task.description.isNotEmpty;
    if (hasSubject) {
      final subject = task.subject;
      return SubjectCard(
        title: task.title,
        trailingWidget: checkBox,
        color: subject.color,
        onTap: () => _openTask(context),
        dense: hasDescription,
        subtitle: task.subject.name,
        trailingSubtitle: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(dateString),
        ),
        bottom: hasDescription
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(task.description),
              )
            : null,
        endPadding: false,
      );
    } else {
      return Card(
        child: InkWell(
          onTap: () => _openTask(context),
          child: Padding(
            padding: EdgeInsets.only(left: 8, bottom: hasDescription ? 8 : 0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(dateString),
                      checkBox,
                    ],
                  ),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key key, @required this.taskStatus}) : super(key: key);

  final TaskStatus taskStatus;

  @override
  Widget build(BuildContext context) {
    // Stream builder
    final taskVM = context.watch<TaskVM>();
    return StreamBuilder<List<Task>>(
      stream: taskVM.taskStreamFromStatus(taskStatus),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Task> tasks = snapshot.data;

          if (taskStatus == TaskStatus.CURRENT) {
            if (tasks.isEmpty) {
              return EmptyPlaceholder(
                text: 'No tasks left!',
                svgPath: IMG_TASKS,
              );
            }

            return _CurrentTasksList(tasks: tasks);
          } else {
            if (tasks.isEmpty) {
              if (taskStatus == TaskStatus.OVERDUE) {
                return EmptyPlaceholder(
                  text: 'No overdue tasks.',
                  svgPath: IMG_TASKS,
                );
              } else {
                return EmptyPlaceholder(
                  text: 'No tasks completed.',
                  svgPath: IMG_TASKS,
                );
              }
            }
            return ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 84),
              itemBuilder: (BuildContext context, int index) {
                return _TaskCard(task: tasks[index]);
              },
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else {
          return ErrorMessage();
        }
      },
    );
  }
}

class _CurrentTasksList extends StatelessWidget {
  const _CurrentTasksList({Key key, @required this.tasks}) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    // TODO split into time frame segments e.g. this week, next week
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 84),
      itemBuilder: (context, index) {
        return _TaskCard(task: tasks[index]);
      },
    );
  }
}
