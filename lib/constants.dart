// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String URL_DISCORD = 'https://discord.gg/N2YK5uq';
const String URL_INSTAGRAM = 'https://instagram.com/cheonapp';
const String URL_WEBSITE = 'https://cheon.app';
const String URL_PRIVACY_POLICY = '$URL_WEBSITE/privacy_policy';
const String URL_TERMS_AND_CONDITIONS = '$URL_WEBSITE/terms_and_conditions';
const String URL_POMODORO_TECHNIQUE =
    'https://en.wikipedia.org/wiki/Pomodoro_Technique';
const String URL_ROADMAP =
    'https://www.notion.so/822ef39ffbde4b308b0e9a6be629bbc7?v=8fa2d150f76546b4b7132d8da86bb7aa';

const String IMG_FORGOT_PASSWORD = 'assets/images/forgot_password.svg';
const String IMG_ADD_TEACHER = 'assets/images/add_teacher.svg';
const String IMG_EMPTY = 'assets/images/empty.svg';
const String IMG_LOGO = 'assets/logo/logo.png';
const String IMG_DEPARTING = 'assets/images/departing.svg';
const String IMG_TERMS = 'assets/images/terms.svg';
const String IMG_LESSON = 'assets/images/lesson.svg';
const String IMG_TIMELINE = 'assets/images/timeline.svg';
const String IMG_TASKS = 'assets/images/tasks.svg';
const String IMG_EXAMS = 'assets/images/exams.svg';
const String IMG_REVISION = 'assets/images/revision.svg';
const String IMG_SUBJECTS = 'assets/images/subjects.svg';
const String IMG_TEACHER = 'assets/images/teacher.svg';
const String IMG_SMART_REVISION = 'assets/images/smart_revision.svg';
const String IMG_STUDYING = 'assets/images/studying.svg';

const String KEY_USER = 'user';
const String KEY_REVISION_BOX = 'revision';

/// 100 milliseconds
const Duration DURATION_SHORT = Duration(milliseconds: 100);

/// 300 milliseconds
const Duration DURATION_MEDIUM = Duration(milliseconds: 300);

/// 500 milliseconds
const Duration DURATION_LONG = Duration(milliseconds: 500);

/// 800 milliseconds
const Duration DURATION_EXTRA_LONG = Duration(milliseconds: 800);

/// Maps a subject category string to a corresponding icon.
const Map<String, IconData> subjectIconMap = <String, IconData>{
  'science': FontAwesomeIcons.flask,
  'maths': FontAwesomeIcons.calculator,
  'literature': FontAwesomeIcons.bookOpen,
  'geography': FontAwesomeIcons.globeEurope,
  'technology': FontAwesomeIcons.laptopCode,
  'social': FontAwesomeIcons.brain,
};

/// Maps a subject icon to it's corresponding id
final Map<IconData, String> iconSubjectMap = <IconData, String>{
  FontAwesomeIcons.flask: 'science',
  FontAwesomeIcons.calculator: 'maths',
  FontAwesomeIcons.bookOpen: 'literature',
  FontAwesomeIcons.globeEurope: 'geography',
  FontAwesomeIcons.laptopCode: 'technology',
  FontAwesomeIcons.brain: 'social',
};
