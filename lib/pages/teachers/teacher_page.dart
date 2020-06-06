import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/widgets/tap_to_dismiss.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/validators.dart';
import 'package:cheon/view_models/teachers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key key, this.teacher}) : super(key: key);

  static const String routeName = '/teacher';
  final Teacher teacher;

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool editable;

  @override
  void initState() {
    super.initState();
    editable = widget.teacher != null;
    _nameController = TextEditingController(text: widget.teacher?.name);
    _emailController = TextEditingController(text: widget.teacher?.email);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  Future<void> deleteTeacher() async {
    if (editable == false) return;
    final TeachersVM teachersVM = context.read<TeachersVM>();
    Navigator.pop(context);
    return teachersVM.deleteTeacher(widget.teacher);
  }

  Future<void> updateName(String name) async {
    if (editable == false) return;

    final TeachersVM teachersVM = context.read<TeachersVM>();
    return teachersVM.updateTeacher(widget.teacher, name: name);
  }

  Future<void> updateEmail(String email) async {
    if (editable == false) return;
    final TeachersVM teachersVM = context.read<TeachersVM>();
    return teachersVM.updateTeacher(widget.teacher, email: email);
  }

  bool canAdd() => _nameController.text.trim().isNotEmpty;

  Future<void> addTeacher() async {
    if (_formKey.currentState.validate() == false) return;

    final String name = _nameController.text;
    final String email = _emailController.text;
    final TeachersVM vm = context.read<TeachersVM>();

    await vm.addTeacher(name: name, email: email.isNotEmpty ? email : null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TapToDismiss(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${!editable ? 'Add ' : ''}Teacher'),
          actions: <Widget>[
            editable
                ? IconButton(
                    icon: const Icon(FontAwesomeIcons.trashAlt),
                    onPressed: deleteTeacher,
                    tooltip: 'Delete Teacher',
                  )
                : const SizedBox.shrink(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey,
            autovalidate: editable,
            // Rebuilds the ui so that the add button can be enabled/disabled
            // when eligible
            onChanged: () => setState(() {}),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: updateName,
                  validator: validateName,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: updateEmail,
                  validator: (String email) => validateEmail(
                    email,
                    isRequired: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SvgPicture.asset(
                      IMG_ADD_TEACHER,
                      alignment: const Alignment(0, -0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: !editable
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryActionButton(
                  onTap: canAdd() ? addTeacher : null,
                  text: 'ADD',
                ),
              )
            : null,
      ),
    );
  }
}
