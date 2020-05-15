import 'package:animations/animations.dart';
import 'package:cheon/components/custom_selection_dialog.dart';
import 'package:cheon/components/subject_card.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/pages/add_subject_page.dart';
import 'package:cheon/view_models/subjects_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a dialog containing a list of subjects
Future<Subject> showSelectSubjectDialog({
  @required BuildContext context,
  Subject selectedSubject,
}) {
  return showModal<Subject>(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (BuildContext context) {
      return StreamBuilder<List<Subject>>(
        stream: context.select<SubjectsVM, Stream<List<Subject>>>(
          (SubjectsVM vm) => vm.subjectsStream,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
          final List<Subject> subjects = snapshot.data ?? <Subject>[];
          return CustomSelectionDialog(
            title: 'Subjects',
            action: CustomSelectionDialogAction(
              tooltip: 'Add Subject',
              onPressed: () => Navigator.pushNamed(
                context,
                AddSubjectPage.routeName,
              ),
            ),
            items: subjects
                .map(
                  (Subject subject) => _SubjectCard(
                    subject: subject,
                    selected: selectedSubject?.id == subject.id,
                  ),
                )
                .toList(),
          );
        },
      );
    },
  );
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({Key key, @required this.subject, @required this.selected})
      : assert(subject != null),
        super(key: key);

  final Subject subject;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      title: subject.name,
      subtitle: subject.teacher?.name,
      trailingWidget: Icon(subject.icon, size: 16),
      color: subject.color,
      onTap: () => Navigator.pop(context, subject),
      dense: subject.teacher != null,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}
