// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/pages/subjects/widgets/select_color_card.dart';
import 'package:cheon/pages/subjects/widgets/select_icon_card.dart';
import 'package:cheon/view_models/subjects_view_model.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/widgets/select_teacher_card.dart';

/// Creates a page to view and edit the details of an individual subject
class ViewSubjectPage extends StatefulWidget {
  const ViewSubjectPage({Key key, this.subject}) : super(key: key);
  static const String routeName = '/subject';
  final Subject subject;

  @override
  _ViewSubjectPageState createState() => _ViewSubjectPageState();
}

class _ViewSubjectPageState extends State<ViewSubjectPage> {
  Color _color;
  String _name;

  @override
  void initState() {
    super.initState();
    final subject = widget.subject;
    _color = subject.color;
    _name = subject.name;
  }

  Future<void> _deleteSubject() async {
    final subjectVM = context.read<SubjectsVM>();
    Navigator.pop(context);
    await subjectVM.deleteSubject(widget.subject);
  }

  Future<void> _setName(String name) async {
    setState(() => _name = name);
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.updateSubject(widget.subject, name: name);
  }

  Future<void> _setColor(Color color) async {
    setState(() => _color = color);
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.updateSubject(widget.subject, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: _name,
      color: _color,
      primaryActionEnabled: false,
      showEditButton: false,
      extraAction: IconButton(
        onPressed: _deleteSubject,
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        tooltip: 'Delete',
      ),
      child: _SubjectBody(
        subject: widget.subject,
        name: _name,
        onNameChanged: _setName,
        color: _color,
        onColorChanged: _setColor,
      ),
    );
  }
}

class _SubjectBody extends StatefulWidget {
  const _SubjectBody({
    Key key,
    @required this.subject,
    @required this.name,
    @required this.onNameChanged,
    @required this.color,
    @required this.onColorChanged,
  }) : super(key: key);

  final Subject subject;
  final String name;
  final ValueChanged<String> onNameChanged;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  __SubjectBodyState createState() => __SubjectBodyState();
}

class __SubjectBodyState extends State<_SubjectBody> {
  TextEditingController _nameController;
  TextEditingController _roomController;

  IconData _icon;
  Teacher _teacher;

  @override
  void initState() {
    super.initState();
    final subject = widget.subject;
    _nameController = TextEditingController(text: subject.name);
    _roomController = TextEditingController(text: subject.room);
    _icon = subject.icon;
    _teacher = subject.teacher;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _roomController.dispose();
  }

  Future<void> _setRoom(String room) async {
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.updateSubject(widget.subject, room: room);
  }

  Future<void> _setTeacher(Teacher teacher) async {
    setState(() => _teacher = teacher);
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.updateSubject(widget.subject, teacher: teacher);
  }

  Future<void> _setIcon(IconData icon) async {
    setState(() => _icon = icon);
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.updateSubject(widget.subject, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      children: [
        // Name
        TextField(
          onChanged: widget.onNameChanged,
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 4),
        // Color & Icon
        Row(
          children: [
            Expanded(
              child: SelectColorCard(
                color: widget.color,
                onColorChanged: widget.onColorChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SelectIconCard(icon: _icon, onIconChanged: _setIcon),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Room
        TextField(
          onChanged: _setRoom,
          controller: _roomController,
          decoration: InputDecoration(labelText: 'Room'),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 4),
        SelectTeacherCard(teacher: _teacher, onTeacherChanged: _setTeacher)
      ],
    );
  }
}
