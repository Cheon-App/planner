// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart' hide Subject;

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/database/daos/subject_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/teacher.dart';
import 'package:cheon/models/subject.dart';

class SubjectRepository {
  SubjectRepository._internal() {
    _dao.subjectListStream().listen(_subjectListSubject.add);
  }

  static SubjectRepository get instance => _singleton;

  static final SubjectRepository _singleton = SubjectRepository._internal();

  final SubjectDao _dao = container<Database>().subjectDao;

  final BehaviorSubject<List<Subject>> _subjectListSubject =
      BehaviorSubject<List<Subject>>();
  Stream<List<Subject>> get subjectListStream => _subjectListSubject.stream;

  Future<void> addSubject({
    @required String name,
    @required Color color,
    @required IconData icon,
    String room,
    Teacher teacher,
  }) {
    return _dao.addSubject(
      name: name,
      color: color,
      iconId: iconSubjectMap[icon],
      room: room,
      teacher: teacher,
    );
  }

  Future<void> deleteSubject(Subject subject) => _dao.deleteSubject(subject);

  Future<void> updateSubject(
    Subject subject, {
    String name,
    Color color,
    IconData icon,
    Teacher teacher,
    String room,
  }) =>
      _dao.updateSubject(
        subject,
        name: name,
        color: color,
        iconId: icon != null ? iconSubjectMap[icon] : null,
        teacher: teacher,
        room: room,
      );
}
