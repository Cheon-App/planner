import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/task.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/timetable_position.dart';
import 'package:cheon/pages/add_event/add_event_page.dart';
import 'package:cheon/pages/lessons/add_lesson_page.dart';
import 'package:cheon/pages/subjects/add_subject_page.dart';
import 'package:cheon/pages/tasks/tasks_page.dart';
import 'package:cheon/pages/exams/exams_page.dart';
import 'package:cheon/pages/home/home_page.dart';
import 'package:cheon/pages/lessons/lessons_page.dart';
import 'package:cheon/pages/preferences/preferences_page.dart';
import 'package:cheon/pages/study/study_page.dart';
import 'package:cheon/pages/subjects/subjects_page.dart';
import 'package:cheon/pages/teachers/teacher_page.dart';
import 'package:cheon/pages/teachers/teachers_page.dart';
import 'package:cheon/pages/timetable/timetable_page.dart';
import 'package:cheon/pages/timetable/timetable_settings_page.dart';
import 'package:cheon/pages/exams/view_exam_page.dart';
import 'package:cheon/pages/lessons/view_lesson_page.dart';
import 'package:cheon/pages/subjects/view_subject_page.dart';
import 'package:cheon/pages/tasks/view_task_page.dart';
import 'package:cheon/pages/exams/view_test_page.dart';
import 'package:cheon/view_models/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheon/view_models/task_view_model.dart';

/// App routes used by the [Navigator] to navigate between pages
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  // Assessments
  AssessmentsPage.routeName: (_) => const AssessmentsPage(inHomePage: false),
  ViewExamPage.routeName: (BuildContext context) => ViewExamPage(
        exam: routeArguments(context) as Exam,
      ),
  ViewTestPage.routeName: (BuildContext context) => ViewTestPage(
        test: routeArguments(context) as Test,
      ),
  // Lessons
  LessonsPage.routeName: (_) => LessonsPage(),
  AddLessonPage.routeName: (BuildContext context) => AddLessonPage(
        timetablePosition: routeArguments(context) as TimetablePosition,
      ),
  ViewLessonPage.routeName: (BuildContext context) => ViewLessonPage(
        lesson: routeArguments(context) as Lesson,
      ),
  // Tasks
  TasksPage.routeName: (_) => VMProvider<TaskVM>(
        viewModel: (_) => TaskVM(),
        child: const TasksPage(),
      ),
  ViewTaskPage.routeName: (context) => VMProvider<TaskVM>(
        viewModel: (_) => TaskVM(),
        child: ViewTaskPage(task: routeArguments(context) as Task),
      ),
  // Subjects
  SubjectsPage.routeName: (_) => SubjectsPage(),
  AddSubjectPage.routeName: (_) => AddSubjectPage(),
  ViewSubjectPage.routeName: (BuildContext context) => ViewSubjectPage(
        subject: routeArguments(context) as Subject,
      ),
  // Teachers
  TeachersPage.routeName: (_) => const TeachersPage(),
  TeacherPage.routeName: (BuildContext context) => TeacherPage(
        teacher: routeArguments(context) as Teacher,
      ),
  HomePage.routeName: (_) => const HomePage(),
  PreferencesPage.routeName: (_) => const PreferencesPage(inHomePage: false),
  TimetablePage.routeName: (_) => const TimetablePage(inHomePage: false),
  AddEventPage.routeName: (BuildContext context) => MultiProvider(
        providers: [
          Provider<TaskVM>(
            create: (_) => TaskVM(),
            dispose: (__, vm) => vm.dispose(),
          ),
        ],
        child: AddEventPage(
          eventType: routeArguments(context) as EventType,
        ),
      ),
  TimetableSettingsPage.routeName: (_) => const TimetableSettingsPage(),
  StudyPage.routeName: (BuildContext context) => StudyPage(
        studySession: routeArguments(context),
      ),
};

Object routeArguments(BuildContext context) =>
    ModalRoute.of(context).settings.arguments;

class VMProvider<T extends ViewModel> extends StatelessWidget {
  const VMProvider({
    Key key,
    @required this.viewModel,
    this.child,
  }) : super(key: key);

  final T Function(BuildContext context) viewModel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: viewModel,
      child: child,
      dispose: (_, vm) => vm.dispose(),
    );
  }
}
