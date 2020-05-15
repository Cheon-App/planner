import 'package:cheon/database/database.dart';
import 'package:cheon/models/assessment.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/utils.dart';
import 'package:meta/meta.dart';

@immutable
class Test extends Assessment {
  /// Represents a test
  Test({
    @required this.id,
    @required this.subject,
    @required this.name,
    this.content,
    @required this.date,
    @required this.priority,
  })  : assert(subject != null),
        assert(date != null),
        assert(name != null),
        super(strippedDateTime(date));

  factory Test.fromDBModel({
    @required TestModel testModel,
    @required Subject subject,
  }) {
    return Test(
      id: testModel.id,
      date: testModel.date,
      name: testModel.title,
      subject: subject,
      content: testModel.content,
      priority: testModel.priority,
    );
  }

  /// A UUID identifier for this test
  final String id;

  /// The name of this test
  final String name;

  /// A description of the test content
  final String content;

  /// The date this test occurs on
  final DateTime date;

  /// The subject being tested
  final Subject subject;

  /// The importance of this test. 1 to 5.
  final int priority;

  @override
  List<Object> get props => <Object>[id];
}
