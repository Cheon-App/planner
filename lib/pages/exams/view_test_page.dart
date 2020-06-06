import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cheon/widgets/study_session_card.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';

import 'package:provider/provider.dart';

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
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Study sessions for this test',
                style: Theme.of(context).textTheme.headline5,
              ),
              _StudySessionList(test: widget.test),
            ],
          ),
        ),
      ],
    );
  }
}

class _StudySessionList extends StatelessWidget {
  const _StudySessionList({Key key, @required this.test}) : super(key: key);

  final Test test;

  @override
  Widget build(BuildContext context) {
    final ExamsVM examsVM = Provider.of<ExamsVM>(context);
    return StreamBuilder<List<StudySession>>(
      stream: examsVM.studySessionListFromTest(test),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<StudySession>> snapshot,
      ) {
        if (snapshot.hasData) {
          final List<StudySession> studySessionList = snapshot.data;
          if (studySessionList.isNotEmpty) {
            return ListView.builder(
              itemCount: studySessionList.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return StudySessionCard(studySession: studySessionList[index]);
              },
            );
          } else {
            return const EmptyPlaceholder(
              text: 'No study sessions.',
              svgPath: IMG_STUDYING,
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
}
