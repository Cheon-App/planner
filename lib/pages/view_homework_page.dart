import 'package:cheon/components/raised_action_page.dart';
import 'package:cheon/models/homework.dart';
import 'package:cheon/view_models/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cheon/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Creates a page containing details of an individual piece of homework
class ViewHomeworkPage extends StatefulWidget {
  const ViewHomeworkPage({Key key, @required this.homework}) : super(key: key);

  static const String routeName = '/view_homework';
  final Homework homework;

  @override
  _ViewHomeworkPageState createState() => _ViewHomeworkPageState();
}

class _ViewHomeworkPageState extends State<ViewHomeworkPage> {
  bool editMode = false;

  void enableEditing() => setState(() => editMode = true);

  void saveChanges() {
    setState(() => editMode = false);
  }

  Future<void> deleteHomework() async {
    final TaskVM homeworkVM = context.read<TaskVM>();
    Navigator.pop(context);

    await homeworkVM.deleteHomework(widget.homework);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${widget.homework.subject.name} Homework',
      color: widget.homework.subject.color,
      editMode: editMode,
      child: _HomeworkBody(editMode: editMode, homework: widget.homework),
      onEditModeChanged: editMode ? saveChanges : enableEditing,
      // primaryActionTitle: 'SCHEDULE',
      // onPrimaryActionTap: () {},
      onDelete: deleteHomework,
    );
  }
}

class _HomeworkBody extends StatefulWidget {
  const _HomeworkBody(
      {Key key, @required this.homework, @required this.editMode})
      : assert(homework != null),
        assert(editMode != null),
        super(key: key);

  final Homework homework;
  final bool editMode;

  @override
  __HomeworkBodyState createState() => __HomeworkBodyState();
}

class __HomeworkBodyState extends State<_HomeworkBody> {
  TextEditingController _descriptionController;
  double progress;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.homework.description);
    progress = widget.homework.progress;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void updateProgress(double progress) {
    final TaskVM homeworkVM = context.read<TaskVM>();
    homeworkVM.updateHomework(widget.homework, progress: progress);
    setState(() => this.progress = progress);
  }

  void updateDescription(String description) {
    final TaskVM homeworkVM = context.read<TaskVM>();
    homeworkVM.updateHomework(widget.homework, description: description);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(
            FontAwesomeIcons.tasks,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            widget.homework.title,
            style: Theme.of(context).textTheme.headline5,
          ),
          subtitle: Text('${widget.homework.length.inMinutes} minutes'),
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.calendarAlt,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            'Due ${fuzzyTimestamp(widget.homework.due).toLowerCase()}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Progress'),
              Text('${(progress * 100).truncate()}%'),
            ],
          ),
        ),
        Slider.adaptive(
          value: progress,
          onChanged: updateProgress,
          min: 0,
          max: 1,
          divisions: 5,
          label: '${(progress * 100).truncate()}%',
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
            onChanged: updateDescription,
            minLines: 2,
            maxLines: 6,
          ),
        ),
        // TODO show study session(like on the view_revision_page)
      ],
    );
  }
}
