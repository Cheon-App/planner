import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/subject_card.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/pages/lessons/view_lesson_page.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/lessons_view_model.dart';
import 'package:cheon/view_models/timetable_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that lists all of the user's lessons
class LessonsPage extends StatelessWidget {
  static const String routeName = '/lessons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: _LessonsList(),
    );
  }
}

class _LessonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LessonsVM lessonsVM = Provider.of<LessonsVM>(context, listen: false);
    return StreamBuilder<List<Lesson>>(
      stream: lessonsVM.lessonListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Lesson>> snapshot) {
        if (snapshot.hasData) {
          final List<Lesson> lessons = snapshot.data;
          if (lessons.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 84),
              itemCount: lessons.length,
              itemBuilder: (BuildContext context, int index) =>
                  _LessonCard(lesson: lessons[index]),
            );
          } else {
            return const EmptyPlaceholder(
              text: 'No lessons.',
              svgPath: IMG_LESSON,
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }
        return const ErrorMessage();
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({Key key, @required this.lesson})
      : assert(lesson != null),
        super(key: key);

  final Lesson lesson;

  void openLesson(BuildContext context) =>
      Navigator.pushNamed(context, ViewLessonPage.routeName, arguments: lesson);

  @override
  Widget build(BuildContext context) {
    final TimetableVM timetableVM = context.watch<TimetableVM>();

    final DateTime start =
        DateTime(0, 0, 0, lesson.startTime.hour, lesson.startTime.minute);
    final DateTime end = start.add(timetableVM.lessonLength);
    final TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(end);

    final String startTime =
        MaterialLocalizations.of(context).formatTimeOfDay(lesson.startTime);
    final String endTime =
        MaterialLocalizations.of(context).formatTimeOfDay(endTimeOfDay);
    return SubjectCard(
      color: lesson.subject.color,
      title: lesson.subject.name,
      subtitle: lesson.teacher?.name ?? 'No Teacher',
      trailing: lesson.room ?? '--',
      trailingSubtitle: Text(
        '$startTime–$endTime',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      bottom:
          Text('${dayToString(lesson.weekday)} Week ${lesson.timetable.week}'),
      dense: true,
      onTap: () => openLesson(context),
    );
  }
}
