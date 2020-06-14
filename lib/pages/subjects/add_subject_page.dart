// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:cheon/pages/subjects/widgets/select_color_card.dart';
import 'package:cheon/pages/subjects/widgets/select_icon_card.dart';
import 'package:cheon/pages/subjects/widgets/select_teacher_card.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/widgets/tap_to_dismiss.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/view_models/subjects_view_model.dart';

/// Creates a page that allows the user to add a subject to their account
class AddSubjectPage extends StatefulWidget {
  static const String routeName = '/add_subject';

  @override
  _AddSubjectPageState createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  static final Random _random = Random();

  TextEditingController _nameController;
  TextEditingController _roomController;

  // The colour chosen for the subject
  Color _color = Colors.primaries[_random.nextInt(Colors.primaries.length)];
  IconData _icon = subjectIconMap.values.first;
  Teacher _teacher;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roomController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _roomController.dispose();
  }

  Future<void> _addSubject() async {
    if (_formKey.currentState.validate() == false) return;
    final String name = _nameController.text;
    final String room = _roomController.text;
    final subjectsVM = context.read<SubjectsVM>();
    await subjectsVM.addSubject(
      color: _color,
      icon: _icon,
      name: name,
      room: room.isNotEmpty ? room : null,
      teacher: _teacher,
    );
    Navigator.pop(context);
  }

  String _nameValidator(String name) {
    if (name.length > 18) return 'Subject name cannot be over 18 characters.';
    return null;
  }

  bool _canAdd() => _nameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return TapToDismiss(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Subject')),
        body: Form(
          key: _formKey,
          // Rebuilds the ui so that the add button can be enabled/disabled
          // when eligible
          onChanged: () => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                maxLength: 18,
                maxLengthEnforced: false,
                validator: _nameValidator,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SelectColorCard(
                      color: _color,
                      onColorChanged: (color) => setState(() => _color = color),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectIconCard(
                      icon: _icon,
                      onIconChanged: (icon) => setState(() => _icon = icon),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text('OPTIONAL', style: Theme.of(context).textTheme.headline5),
              TextFormField(
                controller: _roomController,
                decoration:
                    const InputDecoration(labelText: 'Room', isDense: true),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 4),
              SelectTeacherCard(
                teacher: _teacher,
                onTeacherChanged: (t) => setState(() => _teacher = t),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryActionButton(
            onTap: _canAdd() ? _addSubject : null,
            text: 'ADD',
          ),
        ),
      ),
    );
  }
}
