import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/widgets/raised_body.dart';
import 'package:cheon/widgets/study_session_card.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page containing the details of the given exam
class ViewExamPage extends StatefulWidget {
  const ViewExamPage({Key key, @required this.exam}) : super(key: key);
  static const String routeName = '/exam';
  final Exam exam;

  @override
  _ViewExamPageState createState() => _ViewExamPageState();
}

class _ViewExamPageState extends State<ViewExamPage> {
  bool editMode = false;

  void enableEditing() => setState(() => editMode = true);

  void saveChanges() {
    setState(() => editMode = false);
  }

  Future<void> deleteExam() {
    final ExamsVM examsVM = context.read<ExamsVM>();
    Navigator.pop(context);
    return examsVM.deleteExam(widget.exam);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${widget.exam.subject.name} Exam',
      color: widget.exam.subject.color,
      editMode: editMode,
      child: _ExamBody(exam: widget.exam, editMode: editMode),
      onEditModeChanged: editMode ? saveChanges : enableEditing,
      onDelete: deleteExam,
    );
  }
}

class _ExamBody extends StatelessWidget {
  const _ExamBody({
    Key key,
    @required this.exam,
    @required this.editMode,
  })  : assert(editMode != null),
        super(key: key);

  final Exam exam;
  final bool editMode;

  void deleteExam() {}

  @override
  Widget build(BuildContext context) {
    return RaisedBody(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              FontAwesomeIcons.calendarAlt,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              fuzzyTimestamp(exam.start),
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(
                    TimeOfDay.fromDateTime(exam.start),
                  ),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(
                    TimeOfDay.fromDateTime(exam.end),
                  ),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.brain,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              exam.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: exam.seat != null
                ? Text(
                    'Seat ${exam.seat}',
                    style: Theme.of(context).textTheme.headline5,
                  )
                : null,
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Study sessions for this exam',
                  style: Theme.of(context).textTheme.headline5,
                ),
                _StudySessionList(exam: exam),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudySessionList extends StatelessWidget {
  const _StudySessionList({Key key, @required this.exam}) : super(key: key);

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final ExamsVM examsVM = Provider.of<ExamsVM>(context);
    return StreamBuilder<List<StudySession>>(
      stream: examsVM.studySessionListFromExam(exam),
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
