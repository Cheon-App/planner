// Project imports:
import 'package:cheon/models/compare_date_time.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/test.dart';

abstract class Assessment extends CompareDateTime {
  /// Inherited by [Exam] and [Test] as they share usage
  Assessment(DateTime compareDateTime) : super(compareDateTime);

  bool get isExam => runtimeType == Exam;
  bool get isTest => runtimeType == Test;
}
