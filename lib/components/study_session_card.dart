import 'package:cheon/components/subject_card.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/pages/study_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudySessionCard extends StatelessWidget {
  const StudySessionCard({Key key, @required this.studySession})
      : assert(studySession != null),
        super(key: key);

  final StudySession studySession;

  void openStudySessionPage(BuildContext context) {
    Navigator.pushNamed(context, StudyPage.routeName, arguments: studySession);
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      onTap: () => openStudySessionPage(context),
      color: studySession.subject.color,
      title: '${studySession.subject.name} Study Session',
      subtitle: studySession.title,
      trailingWidget: Icon(
        studySession.completed
            ? FontAwesomeIcons.check
            : FontAwesomeIcons.times,
        size: 16,
        color: studySession.completed
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.error,
      ),
      trailingSubtitle: Text('${studySession.duration.inMinutes} minutes'),
    );
  }
}
