// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/view_models/subjects_view_model.dart';

/// Creates a page to view and edit the details of an individual subject
class ViewSubjectPage extends StatefulWidget {
  const ViewSubjectPage({Key key, this.subject}) : super(key: key);
  static const String routeName = '/subject';
  final Subject subject;

  @override
  _ViewSubjectPageState createState() => _ViewSubjectPageState();
}

class _ViewSubjectPageState extends State<ViewSubjectPage> {
  bool editMode = false;

  void enableEditing() => setState(() => editMode = true);

  void saveChanges() {
    setState(() => editMode = false);
  }

  @override
  Widget build(BuildContext context) {
    final SubjectsVM subjectsVM = Provider.of(context);
    return RaisedActionPage(
      appBarTitle: widget.subject.name,
      color: widget.subject.color,
      editMode: editMode,
      child: _SubjectBody(subject: widget.subject, editMode: editMode),
      onEditModeChanged: editMode ? saveChanges : enableEditing,
      onDelete: () {
        subjectsVM.deleteSubject(widget.subject);
        Navigator.pop(context);
      },
    );
  }
}

class _SubjectBody extends StatefulWidget {
  const _SubjectBody({
    Key key,
    @required this.subject,
    @required this.editMode,
  })  : assert(subject != null),
        assert(editMode != null),
        super(key: key);

  final Subject subject;
  final bool editMode;

  @override
  __SubjectBodyState createState() => __SubjectBodyState();
}

class __SubjectBodyState extends State<_SubjectBody> {
  TextEditingController _nameController;
  TextEditingController _roomController;

  Color color;
  IconData icon;
  Teacher teacher;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _roomController = TextEditingController(text: widget.subject.room);
    color = widget.subject.color;
    icon = widget.subject.icon;
    teacher = widget.subject.teacher;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _roomController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Icon(
            widget.subject.icon,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
            size: MediaQuery.of(context).size.longestSide * 0.2,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            //
          ],
        ),
      ],
    );
  }
}
