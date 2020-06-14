// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cheon/models/teacher.dart';
import 'package:cheon/widgets/select_teacher_dialog.dart';

class SelectTeacherCard extends StatelessWidget {
  const SelectTeacherCard({
    Key key,
    @required this.teacher,
    @required this.onTeacherChanged,
  }) : super(key: key);

  final Teacher teacher;
  final ValueChanged<Teacher> onTeacherChanged;

  Future<void> _selectTeacher(BuildContext context) async {
    final Teacher teacher = await showSelectTeacherDialog(
      context: context,
      selectedTeacher: this.teacher,
    );

    if (teacher != null) onTeacherChanged(teacher);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Teacher'),
        trailing: teacher != null
            ? Text(teacher.name)
            : Icon(FontAwesomeIcons.chevronDown),
        onTap: () => _selectTeacher(context),
      ),
    );
  }
}
