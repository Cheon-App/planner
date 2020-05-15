import 'package:cheon/database/database.dart';
import 'package:cheon/dependency_injection.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/repositories/study_repository.dart';
import 'package:cheon/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../placeholder_data.dart';

void main() {
  group('StudyRepository', () {
    Database database;
    setUp(() async {
      container.registerInstance<QueryExecutor, LazyDatabase>(
        VmDatabase.memory(),
      );
      database = Database.instance;
    });

    tearDown(() async {
      await database.close();
      container.clear();
    });

    group('generateRevisionBlocks', () {});
  });

  group('WeightedAssessment', () {
    test(
      'should be configured correctly when adding an exam',
      () async {
        // ACT
        final Exam exam = placeholderExam;
        final WeightedAssessment assessment = WeightedAssessment.fromExam(exam);

        // ASSERT
        expect(assessment.id, exam.id);
        expect(assessment.type, AssessmentType.EXAM);
        expect(assessment.userPriority, exam.priority);
        expect(assessment.date, strippedDateTime(exam.start));
        expect(assessment.subject, exam.subject);
      },
    );
    test(
      'should be configured correctly when adding a test',
      () async {
        // ACT
        final Test test = placeholderTest;
        final WeightedAssessment assessment = WeightedAssessment.fromTest(test);

        // ASSERT
        expect(assessment.id, test.id);
        expect(assessment.type, AssessmentType.TEST);
        expect(assessment.userPriority, test.priority);
        expect(assessment.date, strippedDateTime(test.date));
        expect(assessment.subject, test.subject);
      },
    );
  });
}
