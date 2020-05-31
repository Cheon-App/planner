import 'dart:async';

import 'package:cheon/database/daos/task_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/homework.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/repositories/homework_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class TaskVM {
  TaskVM() {
    subscriptions = [
      _taskDao.currentTasksStream().listen(_currentTasksSubject.add),
      _taskDao.overdueTasksStream().listen(_overdueTasksSubject.add),
      _taskDao.completedTasksStream().listen(_completedTasksSubject.add),
    ];
  }

  final HomeworkRepository _homeworkRepository = HomeworkRepository.instance;
  final TaskDao _taskDao = Database.instance.taskDao;

  final BehaviorSubject<List<Task>> _currentTasksSubject =
      BehaviorSubject<List<Task>>();
  final BehaviorSubject<List<Task>> _overdueTasksSubject =
      BehaviorSubject<List<Task>>();
  final BehaviorSubject<List<Task>> _completedTasksSubject =
      BehaviorSubject<List<Task>>();

  List<StreamSubscription> subscriptions = [];

  /// A stream of homework either due in the future or overdue
  Stream<List<Homework>> get currentHomeworkStream =>
      _homeworkRepository.currentHomeworkListStream;

  /// A stream of homework due in the past including overdue homework
  Stream<List<Homework>> get pastHomeworkStream =>
      _homeworkRepository.pastHomeworkListStream;



  Future<void> addTask({
    @required String title,
    @required DateTime date,
    @required String note,
    @required Subject subject,
  }) {
    return _taskDao.addTask(
      title: title,
      date: date,
      note: note,
      subject: subject,
    );
  }

  Future<void> completeTask(Task task) => updateTask(
        task,
        complete: !task.completed,
        subject: task.subject,
      );

  Future<void> deleteTask(Task task) => _taskDao.deleteTask(task);

  Future<void> updateTask(
    Task task, {
    bool complete,
    String title,
    String note,
    DateTime date,
    @required Subject subject,
  }) {
    return _taskDao.updateTask(
      task,
      completed: complete,
      note: note,
      title: title,
      date: date,
      subject: subject,
    );
  }

  void dispose() {
    _currentTasksSubject.close();
    _overdueTasksSubject.close();
    _completedTasksSubject.close();
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
  }
}
