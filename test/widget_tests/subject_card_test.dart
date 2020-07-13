// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../test_utils.dart';
import 'package:cheon/widgets/subject_card.dart';

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
