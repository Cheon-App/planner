// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/widgets/select_subject_card.dart';
import 'package:cheon/widgets/select_teacher_card.dart';
import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/widgets/tap_to_dismiss.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/timetable_position.dart';
import 'package:cheon/view_models/timetable_view_model.dart';

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
  Subject _subject;
  Teacher _teacher;
  String note;

  final TextEditingController _roomController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _roomController.dispose();
  }

  void _setSubject(Subject subject) {
    setState(() {
      // Update teacher
      if (subject.teacher != null && _teacher == null) {
        _teacher = subject.teacher;
      }
      // Update room
      if (subject.room != null && _roomController.text.isEmpty) {
        _roomController.text = subject.room;
      }
      // Update subject
      _subject = subject;
    });
  }

  void _updateNote(String note) {
    if (note == null) return;
    setState(() {
      this.note = note;
    });
  }

  Future<void> _addLesson() async {
    final TimetableVM timetableVM = context.read<TimetableVM>();
    if (_subject == null) {
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
      subject: _subject,
      teacher: _teacher,
      room: _roomController.text,
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
                child: SelectSubjectCard(
                  subject: _subject,
                  onSubjectChanged: _setSubject,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          SelectTeacherCard(
            teacher: _teacher,
            onTeacherChanged: (t) => setState(() => _teacher = t),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Note',
              alignLabelWithHint: true,
            ),
            onChanged: _updateNote,
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
              onTap: _subject != null ? () => _addLesson() : null,
            ),
          ),
        ],
      ),
    );
  }
}
