import 'package:cheon/components/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  group('subject_card.dart |', () {
    final Widget subjectCard = Material(
      color: Colors.black,
      child: SubjectCard(
        color: Colors.black,
        subtitle: 'Subtitle',
        title: 'Title',
        trailing: 'Trailing',
        onTap: () {},
      ),
    );
    /* testWidgets(
      'Text contrast ratio is sufficient',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(testableWidget(child: subjectCard));

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      },
    ); */

    testWidgets('Tap target is large enough', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        testableWidget(child: Center(child: subjectCard)),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });
}
