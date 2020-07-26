// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/pages/teachers/teacher_page.dart';
import 'package:cheon/view_models/teachers_view_model.dart';
import 'package:cheon/widgets/custom_selection_dialog.dart';

/// Displays a dialog containing a list of teachers
Future<Teacher> showSelectTeacherDialog({
  @required BuildContext context,
  Teacher selectedTeacher,
}) async {
  return showModal<Teacher>(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (BuildContext context) {
      return StreamBuilder<List<Teacher>>(
        stream: context.select<TeachersVM, Stream<List<Teacher>>>(
          (TeachersVM vm) => vm.teacherListStream,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Teacher>> snapshot) {
          final List<Teacher> teachers = snapshot.data ?? <Teacher>[];
          return CustomSelectionDialog(
            title: 'Teachers',
            action: CustomSelectionDialogAction(
              tooltip: 'Add Teacher',
              onPressed: () => Navigator.pushNamed(
                context,
                TeacherPage.routeName,
              ),
            ),
            items: teachers
                .map(
                  (Teacher teacher) => _TeacherCard(
                    teacher: teacher,
                    onTap: () => Navigator.pop(context, teacher),
                    selected: teacher.id == selectedTeacher?.id,
                  ),
                )
                .toList(),
          );
        },
      );
    },
  );
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    Key key,
    @required this.onTap,
    @required this.teacher,
    @required this.selected,
  })  : assert(onTap != null),
        assert(teacher != null),
        assert(selected != null),
        super(key: key);

  final VoidCallback onTap;
  final Teacher teacher;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CheonApp.borderRadius),
          side: selected
              ? BorderSide(color: Theme.of(context).colorScheme.secondary)
              : BorderSide.none,
        ),
        child: ListTile(
          title: Text(teacher.name),
          subtitle: teacher.email != null ? Text(teacher.email) : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
