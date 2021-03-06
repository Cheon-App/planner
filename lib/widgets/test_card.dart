// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/models/test.dart';
import 'package:cheon/pages/assessments/view_test_page.dart';
import 'package:cheon/widgets/priority_indicator.dart';
import 'package:cheon/widgets/subject_card.dart';

class TestCard extends StatelessWidget {
  /// Creates a card containing test information
  const TestCard({Key key, this.test}) : super(key: key);

  final Test test;

  void openTest(BuildContext context) => Navigator.pushNamed(
        context,
        ViewTestPage.routeName,
        arguments: test,
      );

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      onTap: () => openTest(context),
      color: test.subject.color,
      title: test.name,
      subtitle: '${test.subject.name} | Test',
      trailing: MaterialLocalizations.of(context).formatMediumDate(test.date),
      trailingSubtitle: Row(
        children: <Widget>[
          const Text('Priority:'),
          PriorityIndicator(color: test.subject.color, priority: test.priority),
        ],
      ),
    );
  }
}
