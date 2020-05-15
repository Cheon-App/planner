import 'package:cheon/components/primary_action_button.dart';
import 'package:cheon/components/select_subject_dialog.dart';
import 'package:cheon/components/select_teacher_dialog.dart';
import 'package:cheon/components/tap_to_dismiss.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable_position.dart';
import 'package:cheon/view_models/timetable_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddLessonPage extends StatelessWidget {
  /// Creates a page that allows the user to add a lesson to their account
  const AddLessonPage({
    Key key,
    @required this.timetablePosition,
  })  : assert(timetablePosition != null),
        super(key: key);

  static const String routeName = '/add_lesson';

  final TimetablePosition timetablePosition;

  @override
  Widget build(BuildContext context) {
    return TapToDismiss(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add lesson')),
        body: _Body(timetablePosition: timetablePosition),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.timetablePosition,
  })  : assert(timetablePosition != null),
        super(key: key);

  final TimetablePosition timetablePosition;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  Subject subject;
  Teacher teacher;
  String room;
  String note;

  TextEditingController _roomController;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _roomController.dispose();
  }

  Future<void> selectSubject() async {
    final Subject subject = await showSelectSubjectDialog(context: context);
    if (subject == null || this.subject == subject) return;

    setState(() {
      if (subject.teacher != null && teacher == null) {
        teacher = subject.teacher;
      }
      if (subject.room != null && room == null) {
        _roomController.text = subject.room;
      }
      this.subject = subject;
    });
  }

  Future<void> selectTeacher() async {
    final Teacher teacher = await showSelectTeacherDialog(
      context: context,
      selectedTeacher: this.teacher,
    );
    if (teacher == null) return;
    setState(() {
      this.teacher = teacher;
    });
  }

  void updateRoom(String room) {
    if (room == null) return;
    setState(() {
      this.room = room;
    });
  }

  void updateNote(String note) {
    if (note == null) return;
    setState(() {
      this.note = note;
    });
  }

  Future<void> addLesson() async {
    final TimetableVM timetableVM = context.read<TimetableVM>();
    if (subject == null) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject.')),
      );
      return;
    }

    Navigator.pop(context);
    return timetableVM.addLesson(
      timetable: widget.timetablePosition.timetable,
      period: widget.timetablePosition.period,
      weekday: widget.timetablePosition.weekday,
      subject: subject,
      teacher: teacher,
      room: room,
      note: note,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: IntrinsicHeight(
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                            color: subject?.color ?? Colors.grey, width: 4),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              subject != null ? subject.name : 'Subject',
                            ),
                            trailing: Icon(FontAwesomeIcons.chevronDown),
                            onTap: selectSubject,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text(teacher != null ? teacher.name : 'Teacher'),
                    trailing: Icon(FontAwesomeIcons.chevronDown),
                    onTap: selectTeacher,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _roomController,
            decoration: const InputDecoration(
              labelText: 'Room',
              alignLabelWithHint: true,
            ),
            onChanged: updateRoom,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Note',
              alignLabelWithHint: true,
            ),
            onChanged: updateNote,
            minLines: 2,
            maxLines: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(
                IMG_LESSON,
                alignment: const Alignment(0, -0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: PrimaryActionButton(
              text: 'ADD',
              onTap: subject != null ? () => addLesson() : null,
            ),
          ),
        ],
      ),
    );
  }
}
