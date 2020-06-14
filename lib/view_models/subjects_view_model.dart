// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/repositories/subject_repository.dart';

class SubjectsVM {
  final SubjectRepository subjectRepository = SubjectRepository.instance;

  Stream<List<Subject>> get subjectsStream =>
      subjectRepository.subjectListStream;

  Future<void> addSubject({
    @required String name,
    @required Color color,
    @required IconData icon,
    String room,
    Teacher teacher,
  }) async {
    assert(name != null);
    assert(color != null);
    assert(icon != null);
    return subjectRepository.addSubject(
      color: color,
      icon: icon,
      name: name,
      room: room,
      teacher: teacher,
    );
  }

  Future<void> updateSubject(
    Subject subject, {
    String name,
    Color color,
    IconData icon,
    String room,
    Teacher teacher,
  }) {
    assert(subject != null);
    return subjectRepository.updateSubject(
      subject,
      color: color,
      icon: icon,
      name: name,
      room: room,
      teacher: teacher,
    );
  }

  Future<void> deleteSubject(Subject subject) =>
      subjectRepository.deleteSubject(subject);

  void dispose() {}
}
