// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/study_session.dart';
import 'package:cheon/repositories/study_repository.dart';

class StudyVM {
  StudyVM();

  factory StudyVM.of(BuildContext context, {bool listen = true}) =>
      Provider.of<StudyVM>(context, listen: listen);

  final StudyRepository _studyRepository = StudyRepository.instance;

  Future<void> updateStudySession(StudySession session, {bool completed}) =>
      _studyRepository.updateStudySession(session, completed: completed);

  Future<void> deleteStudySession(StudySession session) =>
      _studyRepository.deleteStudySession(session);

  void dispose() {}
}
