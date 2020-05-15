import 'package:cheon/models/homework.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/models/timetable_position.dart';
import 'package:cheon/pages/add_event_page.dart';
import 'package:cheon/pages/add_inset_day_page.dart';
import 'package:cheon/pages/add_lesson_page.dart';
import 'package:cheon/pages/add_subject_page.dart';
import 'package:cheon/pages/add_year_page.dart';
import 'package:cheon/pages/homework_page.dart';
import 'package:cheon/pages/exams_page.dart';
import 'package:cheon/pages/home_page.dart';
import 'package:cheon/pages/lessons_page.dart';
import 'package:cheon/pages/preferences_page.dart';
import 'package:cheon/pages/study_page.dart';
import 'package:cheon/pages/subjects_page.dart';
import 'package:cheon/pages/teacher_page.dart';
import 'package:cheon/pages/teachers_page.dart';
import 'package:cheon/pages/terms_page.dart';
import 'package:cheon/pages/timetable_page.dart';
import 'package:cheon/pages/timetable_settings_page.dart';
import 'package:cheon/pages/view_homework_page.dart';
import 'package:cheon/pages/view_exam_page.dart';
import 'package:cheon/pages/view_lesson_page.dart';
import 'package:cheon/pages/view_subject_page.dart';
import 'package:cheon/pages/view_test_page.dart';
import 'package:flutter/material.dart';

/// App routes used by the [Navigator] to navigate between pages
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  // Exams
  ExamsPage.routeName: (_) => const ExamsPage(inHomePage: false),
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
  // Homework
  HomeworkPage.routeName: (_) => const HomeworkPage(inHomePage: false),
  ViewHomeworkPage.routeName: (BuildContext context) => ViewHomeworkPage(
        homework: routeArguments(context) as Homework,
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
  AddEventPage.routeName: (BuildContext context) => AddEventPage(
        eventType: routeArguments(context) as EventType,
      ),
  TermsPage.routeName: (_) => const TermsPage(),
  AddInsetDayPage.routeName: (BuildContext context) =>
      AddInsetDayPage(term: routeArguments(context) as Term),
  AddYearPage.routeName: (_) => AddYearPage(),
  TimetableSettingsPage.routeName: (_) => const TimetableSettingsPage(),
  StudyPage.routeName: (BuildContext context) => StudyPage(
        studySession: routeArguments(context),
      ),
};

Object routeArguments(BuildContext context) =>
    ModalRoute.of(context).settings.arguments;
