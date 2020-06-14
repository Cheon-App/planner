import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cheon/database/daos/task_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/view_models/view_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class TaskVM extends ChangeNotifier with ViewModel {
  TaskVM() {
    subscriptions = [
      _taskDao.currentTasksStream().listen((tasks) {
        _currentTasksSubject.add(tasks);
        _currentTasksCount = tasks.length;
        notifyListeners();
      }),
      _taskDao.overdueTasksStream().listen((tasks) {
        _overdueTasksSubject.add(tasks);
        _overdueTasksCount = tasks.length;
        notifyListeners();
      }),
      _taskDao.completedTasksStream().listen(_completedTasksSubject.add),
    ];
  }

  final TaskDao _taskDao = container<Database>().taskDao;

  final BehaviorSubject<List<Task>> _currentTasksSubject =
      BehaviorSubject<List<Task>>();
  final BehaviorSubject<List<Task>> _overdueTasksSubject =
      BehaviorSubject<List<Task>>();
  final BehaviorSubject<List<Task>> _completedTasksSubject =
      BehaviorSubject<List<Task>>();

  List<StreamSubscription> subscriptions = [];

  Stream<List<Task>> get currentTasksStream => _currentTasksSubject.stream;
  Stream<List<Task>> get overdueTasksStream => _overdueTasksSubject.stream;
  Stream<List<Task>> get completedTasksStream => _completedTasksSubject.stream;

  Stream<List<Task>> taskStreamFromStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.CURRENT:
        return currentTasksStream;
        break;
      case TaskStatus.OVERDUE:
        return overdueTasksStream;
        break;
      case TaskStatus.COMPLETE:
        return completedTasksStream;
        break;
    }
    return null;
  }

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
        completed: !task.completed,
        subject: task.subject,
      );

  Future<void> deleteTask(Task task) => _taskDao.deleteTask(task);

  Future<void> updateTask(
    Task task, {
    bool completed,
    String title,
    String description,
    DateTime due,
    @required Subject subject,
  }) {
    return _taskDao.updateTask(
      task,
      completed: completed,
      note: description,
      title: title,
      date: due,
      subject: subject,
    );
  }

  int _overdueTasksCount = 0;
  int get overdueTasksCount => _overdueTasksCount;

  int _currentTasksCount = 0;
  int get currentTasksCount => _currentTasksCount;

  @override
  void dispose() {
    _currentTasksSubject.close();
    _overdueTasksSubject.close();
    _completedTasksSubject.close();
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

enum TaskStatus { CURRENT, OVERDUE, COMPLETE }
