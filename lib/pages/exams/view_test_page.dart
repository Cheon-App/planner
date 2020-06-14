// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:cheon/utils.dart';

/// Creates a page containing the details of the given test
class ViewTestPage extends StatefulWidget {
  const ViewTestPage({Key key, @required this.test})
      : assert(test != null),
        super(key: key);
  static const String routeName = '/test';
  final Test test;

  @override
  _ViewTestPageState createState() => _ViewTestPageState();
}

class _ViewTestPageState extends State<ViewTestPage> {
  bool editMode = false;

  void toggleEditMode() {
    setState(() => editMode = !editMode);
  }

  Future<void> deleteTest() {
    final ExamsVM examsVM = context.read<ExamsVM>();
    Navigator.pop(context);
    return examsVM.deleteTest(widget.test);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${widget.test.subject.name} Test',
      color: widget.test.subject.color,
      editMode: editMode,
      child: _TestBody(test: widget.test),
      onEditModeChanged: toggleEditMode,
      onDelete: deleteTest,
    );
  }
}

class _TestBody extends StatefulWidget {
  const _TestBody({
    Key key,
    @required this.test,
  })  : assert(test != null),
        super(key: key);

  final Test test;

  @override
  __TestBodyState createState() => __TestBodyState();
}

class __TestBodyState extends State<_TestBody> {
  TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.test.content);
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
  }

  Future<void> updateContent(String content) {
    final ExamsVM examsVM = context.read<ExamsVM>();
    return examsVM.updateTest(widget.test, content: content);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(
            FontAwesomeIcons.calendarAlt,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            '${fuzzyTimestamp(widget.test.date)}',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.brain,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            widget.test.name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Test Content',
              alignLabelWithHint: true,
            ),
            onChanged: updateContent,
            minLines: 2,
            maxLines: 6,
          ),
        ),
      ],
    );
  }
}
