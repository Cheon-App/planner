import 'package:cheon/models/exam.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/test.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Subject placeholderSubject = Subject(
  id: 'id',
  color: Colors.red,
  name: 'name',
  icon: FontAwesomeIcons.laptopCode,
  teacher: placeholderTeacher,
);

final Teacher placeholderTeacher = Teacher(name: 'name', id: 'id');

final Exam placeholderExam = Exam(
  priority: 3,
  location: 'location',
  seat: 'seat',
  subject: placeholderSubject,
  start: DateTime.now().add(const Duration(hours: 2)),
  end: DateTime.now().add(const Duration(hours: 4)),
  title: 'title',
  id: 'id',
);

final Test placeholderTest = Test(
  id: 'id',
  date: DateTime.now(),
  name: 'Test',
  priority: 3,
  subject: placeholderSubject,
  content: 'content',
);
