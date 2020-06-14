// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/widgets/select_subject_card.dart';
import 'package:cheon/widgets/select_teacher_card.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/lessons_view_model.dart';
import 'package:cheon/widgets/subject_card.dart';

class ViewLessonPage extends StatefulWidget {
  const ViewLessonPage({
    Key key,
    @required this.lesson,
    this.nested = false,
  })  : assert(lesson != null),
        super(key: key);

  static const String routeName = '/lesson';
  final Lesson lesson;
  // True if this page was navigated to from itself
  final bool nested;

  @override
  _ViewLessonPageState createState() => _ViewLessonPageState();
}

class _ViewLessonPageState extends State<ViewLessonPage> {
  Subject _subject;

  @override
  void initState() {
    super.initState();
    _subject = widget.lesson.subject;
  }

  Future<void> _deleteLesson() {
    final lessonsVM = context.read<LessonsVM>();
    Navigator.pop(context);
    return lessonsVM.deleteLesson(widget.lesson);
  }

  Future<void> _setSubject(Subject subject) async {
    setState(() => _subject = subject);
    final lessonsVM = context.read<LessonsVM>();
    await lessonsVM.updateLesson(widget.lesson, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${_subject.name} lesson',
      color: _subject.color,
      primaryActionEnabled: false,
      showEditButton: false,
      extraAction: IconButton(
        onPressed: _deleteLesson,
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        tooltip: 'Delete',
      ),
      child: _LessonBody(
        lesson: widget.lesson,
        nested: widget.nested,
        subject: _subject,
        onSubjectChanged: _setSubject,
      ),
    );
  }
}

class _LessonBody extends StatefulWidget {
  const _LessonBody({
    Key key,
    @required this.lesson,
    @required this.nested,
    @required this.subject,
    @required this.onSubjectChanged,
  })  : assert(lesson != null),
        super(key: key);

  final Lesson lesson;
  final bool nested;
  final Subject subject;
  final ValueChanged<Subject> onSubjectChanged;

  @override
  __LessonBodyState createState() => __LessonBodyState();
}

class __LessonBodyState extends State<_LessonBody> {
  TextEditingController _noteController;
  TextEditingController _roomController;
  Teacher _teacher;

  @override
  void initState() {
    super.initState();
    final lesson = widget.lesson;
    _noteController = TextEditingController(text: lesson.note);
    _roomController = TextEditingController(text: lesson.room);
    _teacher = lesson.teacher;
  }

  @override
  void didUpdateWidget(_LessonBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson != widget.lesson) {
      _noteController.text = widget.lesson.note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _updateNote(String text) {
    final lessonsVM = context.read<LessonsVM>();
    lessonsVM.updateLesson(widget.lesson, note: text);
  }

  Future<void> _setTeacher(Teacher teacher) async {
    setState(() => _teacher = teacher);
    final lessonsVM = context.read<LessonsVM>();
    await lessonsVM.updateLesson(widget.lesson, teacher: teacher);
  }

  Future<void> _setRoom(String room) async {
    final lessonsVM = context.read<LessonsVM>();
    await lessonsVM.updateLesson(widget.lesson, room: room);
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final timeString =
        MaterialLocalizations.of(context).formatTimeOfDay(lesson.startTime);
    return ListView(
      primary: false,
      padding: const EdgeInsets.only(top: 12),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Card(
                  child: ListTile(
                title: Text(
                  '${dayToString(lesson.weekday)}, Period ${lesson.period} at '
                  '$timeString',
                  textAlign: TextAlign.center,
                ),
              )),
            ],
          ),
        ),
        Divider(height: 4, thickness: 0),
        // Subject & Room
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectSubjectCard(
                      subject: widget.subject,
                      onSubjectChanged: widget.onSubjectChanged,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: _setRoom,
                      controller: _roomController,
                      decoration: InputDecoration(
                        labelText: 'Room',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Teacher
              SelectTeacherCard(
                onTeacherChanged: _setTeacher,
                teacher: _teacher,
              ),
              const SizedBox(height: 8),
              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
                  alignLabelWithHint: true,
                ),
                onChanged: _updateNote,
                minLines: 2,
                maxLines: 2,
              ),
            ],
          ),
        ),
        !widget.nested
            ? Column(
                children: <Widget>[
                  const Divider(height: 0),
                  _OtherLessonsSection(lesson: widget.lesson),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _OtherLessonsSection extends StatefulWidget {
  const _OtherLessonsSection({
    Key key,
    @required this.lesson,
  })  : assert(lesson != null),
        super(key: key);

  final Lesson lesson;

  @override
  __OtherLessonsSectionState createState() => __OtherLessonsSectionState();
}

class __OtherLessonsSectionState extends State<_OtherLessonsSection> {
  Stream<List<Lesson>> _otherLessonsStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final LessonsVM lessonsVM = Provider.of<LessonsVM>(context, listen: false);
    _otherLessonsStream =
        lessonsVM.lessonListFromSubjectStream(widget.lesson.subject);
  }

  void _openLessonPage(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ViewLessonPage(lesson: lesson, nested: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Other ${widget.lesson.subject.name.toLowerCase()} '
                'lessons',
                style: Theme.of(context).textTheme.headline5,
              ),
              StreamBuilder<List<Lesson>>(
                stream: _otherLessonsStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Lesson>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final List<Lesson> lessons = snapshot.data;
                    lessons.removeWhere(
                      (Lesson lesson) => widget.lesson.id == lesson.id,
                    );
                    if (lessons.isNotEmpty) {
                      return ListView.builder(
                        itemCount: lessons.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          final Lesson lesson = lessons[index];
                          return SubjectCard(
                            color: lesson.subject.color,
                            title: '${dayToString(lesson.weekday)} Week '
                                '${lesson.timetable.week}',
                            trailing: MaterialLocalizations.of(context)
                                .formatTimeOfDay(lesson.compareTime),
                            subtitle: lesson.teacher?.name ?? 'No Teacher',
                            trailingSubtitle:
                                lesson.room != null ? Text(lesson.room) : null,
                            onTap: () => _openLessonPage(lesson),
                          );
                        },
                      );
                    } else {
                      return const EmptyPlaceholder(
                        text: 'No other lessons',
                        svgPath: IMG_LESSON,
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingIndicator();
                  }
                  return const ErrorMessage();
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
