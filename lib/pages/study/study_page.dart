// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/view_models/study_view_model.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/raised_action_page.dart';

class StudyPage extends StatefulWidget {
  /// Creates a page where details of a study session can be viewed and edited.
  const StudyPage({Key key, @required this.studySession})
      : assert(studySession != null),
        super(key: key);

  static const String routeName = '/study';

  final StudySession studySession;

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  bool _editMode = false;
  bool _revisionComplete;

  @override
  void initState() {
    super.initState();

    _revisionComplete = widget.studySession.completed;
  }

  String title() => '${widget.studySession.title} Revision';

  Future<void> completeStudySession(bool complete) async {
    final StudyVM studyVM = StudyVM.of(context, listen: false);

    setState(() {
      _revisionComplete = complete;
    });
    await studyVM.updateStudySession(
      widget.studySession,
      completed: _revisionComplete,
    );
  }

  Future<void> deleteStudySession() async {
    final StudyVM studyVM = StudyVM.of(context, listen: false);
    await studyVM.deleteStudySession(widget.studySession);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Subject subject = widget.studySession.subject;
    return RaisedActionPage(
      appBarTitle: title(),
      color: subject?.color ?? Theme.of(context).colorScheme.secondary,
      editMode: _editMode,
      onDelete: deleteStudySession,
      onEditModeChanged: () => setState(() => _editMode = !_editMode),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text(
                      'Date',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: Text(
                      MaterialLocalizations.of(context).formatFullDate(
                        widget.studySession.start,
                      ),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    /* leading: Icon(
                      FontAwesomeIcons.calendarAlt,
                      color: Theme.of(context).iconTheme.color,
                    ), */
                    title: Text(
                      'Time',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          TimeOfDay.fromDateTime(widget.studySession.start),
                        ),
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: CheckboxListTile(
                title: Text(
                  'Completed',
                  style: Theme.of(context).textTheme.headline5,
                ),
                onChanged: completeStudySession,
                value: _revisionComplete,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: EmptyPlaceholder(svgPath: IMG_STUDYING),
            ),
          ),
        ],
      ),
    );
  }
}
