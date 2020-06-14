// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/widgets/select_subject_dialog.dart';

class SelectSubjectCard extends StatelessWidget {
  /// Creates a card containing a subject name and dropdown button to let users
  /// select a subject for an event.
  const SelectSubjectCard({
    Key key,
    this.currentSubject,
    @required this.onSubjectSelected,
    this.isRequired = false,
    this.enabled = true,
  }) : super(key: key);

  /// The selected subject
  final Subject currentSubject;

  /// A callback function invoked when a subject is selected.
  final Function(Subject) onSubjectSelected;

  /// True if a subject must be selected
  final bool isRequired;

  final bool enabled;

  /// Displays the dialog containing a list of subjects that the user can choose
  /// from.
  Future<void> selectSubject(BuildContext context) async {
    final Subject subject = await showSelectSubjectDialog(
      context: context,
      selectedSubject: currentSubject,
    );

    if (subject != null) onSubjectSelected(subject);
  }

  @override
  Widget build(BuildContext context) {
    // The Card containing the subject name and dropdown button used to display
    // the SelectSubject dialog.
    return IntrinsicHeight(
      child: Card(
        child: Row(
          children: <Widget>[
            Container(color: currentSubject?.color ?? Colors.grey, width: 4),
            Expanded(
              child: ListTile(
                title: Text(
                  currentSubject?.name ?? 'Subject${isRequired ? '*' : ''}',
                ),
                trailing: FaIcon(FontAwesomeIcons.chevronDown),
                onTap: () => selectSubject(context),
                enabled: enabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
