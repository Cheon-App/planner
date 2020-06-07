import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cheon/widgets/grid_selection_dialog.dart';
import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/widgets/select_teacher_dialog.dart';
import 'package:cheon/widgets/tap_to_dismiss.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/selection_dialog_widget_item.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/view_models/subjects_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  Color color = Colors.primaries[_random.nextInt(Colors.primaries.length)];
  IconData icon = subjectIconMap.values.first;
  Teacher teacher;

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

  void addSubject() {
    if (_formKey.currentState.validate() == false) return;
    final String name = _nameController.text;
    final String room = _roomController.text;
    final SubjectsVM vm = context.read<SubjectsVM>();
    vm.addSubject(
      color: color,
      icon: icon,
      name: name,
      room: room.isNotEmpty ? room : null,
      teacher: teacher,
    );
    Navigator.pop(context);
  }

  String nameValidator(String name) {
    if (name.length > 18) return 'Subject name cannot be over 18 characters.';
    return null;
  }

  bool canAdd() => _nameController.text.trim().isNotEmpty;

  Future<void> selectColor() async {
    final Color newColor = await showModal<Color>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return GridSelectionDialog<Color>(
          defaultItem: color,
          title: 'Select A Colour',
          items: Colors.primaries
              .map(
                (Color c) => SelectionDialogWidgetItem<Color>(
                  widget: Material(color: c, shape: const CircleBorder()),
                  value: c,
                ),
              )
              .toList(),
        );
      },
    );

    if (newColor != null) {
      setState(() {
        color = newColor;
      });
    }
  }

  Future<void> selectIcon() async {
    final IconData newIcon = await showModal<IconData>(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return GridSelectionDialog<IconData>(
          defaultItem: icon,
          title: 'Select An Icon',
          items: subjectIconMap.values
              .map(
                (IconData i) => SelectionDialogWidgetItem<IconData>(
                  widget: Icon(i),
                  value: i,
                ),
              )
              .toList(),
        );
      },
    );

    if (newIcon != null) {
      setState(() {
        icon = newIcon;
      });
    }
  }

  Future<void> selectTeacher() async {
    final Teacher teacher = await showSelectTeacherDialog(
      context: context,
      selectedTeacher: this.teacher,
    );

    if (teacher != null) setState(() => this.teacher = teacher);

    print(this.teacher);
  }

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
                validator: nameValidator,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: const Text('Colour'),
                        trailing: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        onTap: selectColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: const Text('Icon'),
                        trailing: Icon(icon),
                        onTap: selectIcon,
                      ),
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
              Card(
                child: ListTile(
                  title: const Text('Teacher'),
                  trailing: teacher != null
                      ? Text(teacher.name)
                      : Icon(FontAwesomeIcons.chevronDown),
                  onTap: () => selectTeacher(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryActionButton(
            onTap: canAdd() ? addSubject : null,
            text: 'ADD',
          ),
        ),
      ),
    );
  }
}
