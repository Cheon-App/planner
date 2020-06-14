// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/widgets/select_date_card.dart';
import 'package:cheon/widgets/select_subject_card.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/view_models/exams_view_model.dart';

/// Creates a page containing the details of the given test
class ViewTestPage extends StatefulWidget {
  const ViewTestPage({Key key, @required this.test})
      : assert(test != null),
        super(key: key);

  final Test test;
  static const String routeName = '/test';

  @override
  _ViewTestPageState createState() => _ViewTestPageState();
}

class _ViewTestPageState extends State<ViewTestPage> {
  Subject _subject;

  @override
  void initState() {
    super.initState();
    _subject = widget.test.subject;
  }

  Future<void> _deleteTest() async {
    final ExamsVM examsVM = context.read<ExamsVM>();
    Navigator.pop(context);
    await examsVM.deleteTest(widget.test);
  }

  Future<void> _setSubject(Subject subject) async {
    setState(() => _subject = subject);
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateTest(widget.test, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${_subject.name} Test',
      color: _subject.color,
      primaryActionEnabled: false,
      showEditButton: false,
      extraAction: IconButton(
        onPressed: _deleteTest,
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        tooltip: 'Delete',
      ),
      child: _TestBody(
        test: widget.test,
        subject: _subject,
        onSubjectChanged: _setSubject,
      ),
      onDelete: _deleteTest,
    );
  }
}

class _TestBody extends StatefulWidget {
  const _TestBody({
    Key key,
    @required this.test,
    @required this.subject,
    @required this.onSubjectChanged,
  })  : assert(test != null),
        super(key: key);

  final Test test;
  final Subject subject;
  final ValueChanged<Subject> onSubjectChanged;

  @override
  __TestBodyState createState() => __TestBodyState();
}

class __TestBodyState extends State<_TestBody> {
  TextEditingController _nameController;
  TextEditingController _contentController;
  TextEditingController _priorityController;

  DateTime _date;

  @override
  void initState() {
    super.initState();
    final test = widget.test;
    _nameController = TextEditingController(text: test.name);
    _contentController = TextEditingController(text: test.content);
    _priorityController = TextEditingController(
      text: '${test.priority}',
    );
    _date = test.date;
  }

  @override
  void dispose() {
    _contentController.dispose();
    _nameController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _setName(String name) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateTest(widget.test, name: name);
  }

  Future<void> _setContent(String content) {
    final examsVM = context.read<ExamsVM>();
    return examsVM.updateTest(widget.test, content: content);
  }

  Future<void> _setDate(DateTime date) async {
    final examsVM = context.read<ExamsVM>();
    setState(() => _date = date);
    await examsVM.updateTest(widget.test, date: date);
  }

  Future<void> _setPriority(String priority) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateTest(widget.test, priority: int.parse(priority));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      children: <Widget>[
        // Name
        TextField(
          onChanged: _setName,
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 4),
        // Date & Subject
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: SelectDateCard(
                  date: _date,
                  onDateSelected: _setDate,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectSubjectCard(
                  onSubjectSelected: widget.onSubjectChanged,
                  currentSubject: widget.subject,
                  isRequired: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Revision Priority
        TextField(
          controller: _priorityController,
          onChanged: _setPriority,
          decoration: InputDecoration(labelText: 'Revision Priority'),
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 8),
        // Content
        TextField(
          controller: _contentController,
          onChanged: _setContent,
          decoration: const InputDecoration(
            labelText: 'Test Content',
            alignLabelWithHint: true,
          ),
          minLines: 2,
          maxLines: 6,
        ),
      ],
    );
  }
}
