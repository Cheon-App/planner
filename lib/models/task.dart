import 'package:cheon/database/database.dart';
import 'package:cheon/models/subject.dart';
import 'package:meta/meta.dart';

class Task {
  Task({
    @required this.id,
    @required this.due,
    @required this.description,
    @required this.completed,
    @required this.title,
    @required this.subject,
  });

  factory Task.fromDbModel(TaskModel model, Subject subject) {
    return Task(
      id: model.id,
      completed: model.completed,
      due: model.due,
      description: model.description,
      title: model.title,
      subject: subject,
    );
  }

  final String id;
  final DateTime due;
  final String description;
  final bool completed;
  final String title;
  // Optional
  final Subject subject;
}
