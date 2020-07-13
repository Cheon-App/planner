// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cheon/models/study_session.dart';
import 'package:cheon/pages/study/study_page.dart';
import 'package:cheon/widgets/subject_card.dart';

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
