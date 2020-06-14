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
    this.subject,
    @required this.onSubjectChanged,
    this.isRequired = false,
    this.enabled = true,
  }) : super(key: key);

  /// The selected subject
  final Subject subject;

  /// A callback function invoked when a subject is selected.
  final Function(Subject) onSubjectChanged;

  /// True if a subject must be selected
  final bool isRequired;

  final bool enabled;

  /// Displays the dialog containing a list of subjects that the user can choose
  /// from.
  Future<void> _selectSubject(BuildContext context) async {
    final Subject subject = await showSelectSubjectDialog(
      context: context,
      selectedSubject: this.subject,
    );

    if (subject != null) onSubjectChanged(subject);
  }

  @override
  Widget build(BuildContext context) {
    // The Card containing the subject name and dropdown button used to display
    // the SelectSubject dialog.
    return IntrinsicHeight(
      child: Card(
        child: Row(
          children: <Widget>[
            Container(color: subject?.color ?? Colors.grey, width: 4),
            Expanded(
              child: ListTile(
                title: Text(
                  subject?.name ?? 'Subject${isRequired ? '*' : ''}',
                ),
                trailing: FaIcon(FontAwesomeIcons.chevronDown),
                onTap: () => _selectSubject(context),
                enabled: enabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
