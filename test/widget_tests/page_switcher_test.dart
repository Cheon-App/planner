// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cheon/widgets/page_switcher.dart';
import '../test_utils.dart';

void main() {
  testWidgets('page_switcher.dart | PageSwitcher behaves as intended', (
    WidgetTester tester,
  ) async {
    const List<Widget> children = <Widget>[Text('1'), Text('2')];
    final StreamController<int> _indexController = StreamController<int>();

    final Widget pageSwitcher = StreamBuilder<int>(
      stream: _indexController.stream,
      initialData: 1,
      builder: (_, AsyncSnapshot<int> snapshot) {
        return PageSwitcher(pageIndex: snapshot.data, children: children);
      },
    );

    // Displays two pages, starting at page 2
    await tester.pumpWidget(testableWidget(child: pageSwitcher));

    // Used to identify the page being shown
    final Finder pageOneFinder = find.text('1');
    final Finder pageTwoFinder = find.text('2');
    // Checks if the correct page is being shown
    expect(pageOneFinder, findsNothing);
    expect(pageTwoFinder, findsOneWidget);
    // Switches to the first page
    _indexController.add(0);
    // Rebuilds the widget
    await tester.pump();
    // Checks if the correct page is being shown
    expect(pageOneFinder, findsOneWidget);
    expect(pageTwoFinder, findsNothing);
  });
}
