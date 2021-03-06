// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/view_models/task_view_model.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/widgets/select_date_card.dart';
import 'package:cheon/widgets/select_subject_card.dart';

class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({Key key, @required this.task}) : super(key: key);
  static const String routeName = '/task';
  final Task task;

  @override
  _ViewTaskPageState createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  Future<void> _deleteTask(BuildContext context) async {
    final taskVM = context.read<TaskVM>();
    Navigator.pop(context);
    await taskVM.deleteTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: 'Task',
      color: widget.task.subject?.color ?? Theme.of(context).primaryColor,
      child: _TaskBody(task: widget.task),
      primaryActionEnabled: false,
      showEditButton: false,
      extraAction: IconButton(
        onPressed: () => _deleteTask(context),
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        tooltip: 'Delete',
      ),
    );
  }
}

class _TaskBody extends StatefulWidget {
  const _TaskBody({Key key, @required this.task}) : super(key: key);
  final Task task;

  @override
  __TaskBodyState createState() => __TaskBodyState();
}

class __TaskBodyState extends State<_TaskBody> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  Task _task;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _task = widget.task;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTitle(String title) {
    final taskVM = context.read<TaskVM>();
    taskVM.updateTask(
      widget.task,
      subject: _task.subject,
      title: title,
    );
  }

  void _updateDescription(String description) {
    final taskVM = context.read<TaskVM>();
    taskVM.updateTask(
      widget.task,
      subject: _task.subject,
      description: description,
    );
  }

  Future<void> _updateDueDate(DateTime due) async {
    if (due == null) return;
    setState(() {
      _task = _task.copyWith(due: due);
    });
    final taskVM = context.read<TaskVM>();
    await taskVM.updateTask(
      widget.task,
      subject: _task.subject,
      due: due,
    );
  }

  Future<void> _updateSubject(Subject subject) async {
    if (subject == null) return;
    setState(() {
      _task = _task.copyWith(subject: subject);
    });
    final taskVM = context.read<TaskVM>();
    await taskVM.updateTask(widget.task, subject: _task.subject);
  }

  Future<void> _completeTask() async {
    setState(() {
      _task = _task.copyWith(completed: !_task.completed);
    });
    final taskVM = context.read<TaskVM>();
    await taskVM.completeTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Title'),
          onChanged: _updateTitle,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: SelectDateCard(
                date: _task.due,
                title: 'Due',
                onDateSelected: _updateDueDate,
                fullDate: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SelectSubjectCard(
                subject: _task.subject,
                onSubjectChanged: _updateSubject,
              ),
            ),
          ],
        ),
        Card(
          child: CheckboxListTile(
            title: Text('Completed'),
            onChanged: (_) => _completeTask(),
            value: _task.completed,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            alignLabelWithHint: true,
          ),
          onChanged: _updateDescription,
          minLines: 2,
          maxLines: null,
        ),
      ],
    );
  }
}

class _SelectSubjectFormCard extends FormField<Subject> {
  _SelectSubjectFormCard({
    Key key,
    @required Subject initialSubject,
    bool subjectRequired = false,
    FormFieldSetter<Subject> onSaved,
    bool enabled = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialSubject,
          builder: (FormFieldState<Subject> state) {
            return SelectSubjectCard(
              onSubjectChanged: state.didChange,
              subject: state.value,
              isRequired: subjectRequired,
              enabled: enabled,
            );
          },
        );
}

class _SelectDateFormCard extends FormField<DateTime> {
  _SelectDateFormCard({
    Key key,
    @required DateTime initialDate,
    FormFieldSetter<DateTime> onSaved,
    bool enabled,
    bool fullDate,
    String title,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialDate,
          builder: (FormFieldState<DateTime> state) {
            return SelectDateCard(
              date: state.value,
              onDateSelected: (date) {
                if (date == null) return;
                state.didChange(date);
              },
              enabled: enabled,
              fullDate: fullDate,
              title: title,
            );
          },
        );
}
