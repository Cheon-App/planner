// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
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
  bool editMode = false;

  void enableEditing() => setState(() => editMode = true);

  void saveChanges() {
    setState(() => editMode = false);
  }

  Future<void> deleteLesson() {
    final LessonsVM lessonsVM = Provider.of<LessonsVM>(context, listen: false);
    Navigator.pop(context);
    return lessonsVM.deleteLesson(widget.lesson);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${widget.lesson.subject.name} lesson',
      color: widget.lesson.subject.color,
      editMode: editMode,
      child: _LessonBody(
        lesson: widget.lesson,
        editMode: editMode,
        nested: widget.nested,
      ),
      onEditModeChanged: editMode ? saveChanges : enableEditing,
      onDelete: deleteLesson,
    );
  }
}

class _LessonBody extends StatefulWidget {
  const _LessonBody({
    Key key,
    @required this.lesson,
    @required this.editMode,
    @required this.nested,
  })  : assert(lesson != null),
        assert(editMode != null),
        super(key: key);

  final Lesson lesson;
  final bool editMode;
  final bool nested;

  @override
  __LessonBodyState createState() => __LessonBodyState();
}

class __LessonBodyState extends State<_LessonBody> {
  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.lesson.note);
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
    super.dispose();
    _noteController.dispose();
  }

  void updateNote(String text) {
    final LessonsVM lessonsVM = Provider.of<LessonsVM>(context, listen: false);
    lessonsVM.updateLesson(widget.lesson, note: text);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            '${dayToString(widget.lesson.weekday)} Week '
            '${widget.lesson.timetable.week}',
            style: Theme.of(context).textTheme.headline5,
          ),
          subtitle: const Text('One hour'),
          trailing: Text(
            MaterialLocalizations.of(context)
                .formatTimeOfDay(widget.lesson.startTime),
            style: Theme.of(context).textTheme.headline5,
          ),
          leading: Icon(
            FontAwesomeIcons.calendarAlt,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        ListTile(
          title: Text(
            widget.lesson.teacher?.name ?? '',
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: Text(
            widget.lesson.room ?? '',
            style: Theme.of(context).textTheme.headline5,
          ),
          leading: Icon(
            FontAwesomeIcons.chalkboardTeacher,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              alignLabelWithHint: true,
            ),
            onChanged: updateNote,
            minLines: 2,
            maxLines: 2,
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

  void openLessonPage(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ViewLessonPage(lesson: lesson, nested: true),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final LessonsVM lessonsVM = Provider.of<LessonsVM>(context, listen: false);
    _otherLessonsStream =
        lessonsVM.lessonListFromSubjectStream(widget.lesson.subject);
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
                            onTap: () => openLessonPage(lesson),
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
