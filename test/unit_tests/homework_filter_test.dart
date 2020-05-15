import 'package:cheon/models/homework.dart';
import 'package:cheon/pages/homework_page.dart';
import 'package:cheon/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import '../placeholder_data.dart';

void main() {
  group('homework_page.dart |', () {
    /// Creates a homework object with the provided values, leaving the rest
    /// empty. If the object should still be present after a list of homework
    /// has been filtered then the id will be set to 'valid' otherwise it's set
    /// to 'invalid'
    Homework homeworkObject({
      @required bool shouldRemain,
      @required DateTime due,
      @required double progress,
    }) {
      return Homework(
        id: shouldRemain ? 'vaild' : 'invalid',
        description: '',
        due: due,
        length: const Duration(),
        progress: progress,
        subject: placeholderSubject,
        title: '',
        scheduled: null,
      );
    }

    void expectValidHomework(
      List<Homework> filteredHomeworkList,
      String functionName,
    ) {
      expect(
        filteredHomeworkList
            .where(
              (Homework homework) => homework.id == 'invalid',
            )
            .toList(),
        isEmpty,
        reason: '$functionName() failed to correctly filter a list of homework',
      );
    }

    final HomeworkPageState homeworkPage = HomeworkPageState();

    final DateTime weekStart = strippedDateTime(startOfWeek(DateTime.now()));
    final DateTime lastWeekStart = weekStart.subtract(const Duration(days: 7));
    // Overwrites the datetime used by the homework page as a reference
    homeworkPage.now = weekStart;
    final DateTime today = weekStart;
    final DateTime tomorrow = today.add(const Duration(days: 1));
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime inTwoDays = tomorrow.add(const Duration(days: 1));
    final DateTime twoDaysAgo = yesterday.subtract(const Duration(days: 1));

    final DateTime nextWeekStart = weekStart.add(const Duration(days: 7));
    final DateTime weekAfterNextWeekStart =
        nextWeekStart.add(const Duration(days: 7));
    test('overdueHomework() only returns incomplete homework due before today.',
        () {
      // provide it a list of homework with specific id's
      // expect a list with the resulting id's matching an id list

      final List<Homework> unfilteredHomework = <Homework>[
        // [Erroneous]
        homeworkObject(due: tomorrow, progress: 0, shouldRemain: false),
        homeworkObject(due: tomorrow, progress: 1, shouldRemain: false),
        homeworkObject(due: today, progress: 0, shouldRemain: false),
        homeworkObject(due: today, progress: 1, shouldRemain: false),
        homeworkObject(due: yesterday, progress: 1, shouldRemain: false),
        homeworkObject(due: twoDaysAgo, progress: 1, shouldRemain: false),
        // [Borderline]
        homeworkObject(due: yesterday, progress: 0, shouldRemain: true),
        // [Valid]
        homeworkObject(due: twoDaysAgo, progress: 0, shouldRemain: true),
      ];

      final List<Homework> filteredHomework =
          homeworkPage.overdueHomework(unfilteredHomework);

      // Only two pieces of overdue homework are provided
      expect(filteredHomework.length, equals(2));

      // No homework that isn't overdue should remain
      expectValidHomework(filteredHomework, 'overdueHomework');
    });

    test('homeworkToday() only returns homework due today.', () {
      final List<Homework> unfilteredHomework = <Homework>[
        // [Erroneous]
        homeworkObject(due: yesterday, progress: 0, shouldRemain: false),
        homeworkObject(due: yesterday, progress: 1, shouldRemain: false),
        homeworkObject(due: tomorrow, progress: 0, shouldRemain: false),
        homeworkObject(due: tomorrow, progress: 1, shouldRemain: false),
        // [Borderline & Valid]
        homeworkObject(due: today, progress: 0, shouldRemain: true),
        homeworkObject(due: today, progress: 1, shouldRemain: true),
      ];

      final List<Homework> filteredHomework =
          homeworkPage.homeworkToday(unfilteredHomework);

      // Only two pieces of overdue homework are provided
      expect(filteredHomework.length, equals(2));

      // No homework that isn't due today should remain
      expectValidHomework(filteredHomework, 'homeworkToday');
    });

    test('homeworkTomorrow() only returns homework due tomorrow.', () {
      final List<Homework> unfilteredHomework = <Homework>[
        // [Erroneous]
        homeworkObject(due: today, progress: 0, shouldRemain: false),
        homeworkObject(due: today, progress: 1, shouldRemain: false),
        homeworkObject(due: inTwoDays, progress: 0, shouldRemain: false),
        homeworkObject(due: inTwoDays, progress: 1, shouldRemain: false),

        // [Borderline & Valid]
        homeworkObject(due: tomorrow, progress: 0, shouldRemain: true),
        homeworkObject(due: tomorrow, progress: 1, shouldRemain: true),
      ];

      final List<Homework> filteredHomework =
          homeworkPage.homeworkTomorrow(unfilteredHomework);

      // Only two pieces of homework due tomorrow are provided
      expect(filteredHomework.length, equals(2));

      // Only homework that meets the test condition should remain
      expectValidHomework(filteredHomework, 'homeworkTomorrow');
    });

    test(
      'homeworkThisWeek() only returns homework due this week excluding '
      'homework due today and tomorrow.',
      () {
        final List<Homework> unfilteredHomework = <Homework>[
          // [Erroneous] Creates homework every day last week and today/tomorrow
          for (int i = 0; i < 9; i++) ...<Homework>[
            for (int j = 0; j < 2; j++)
              homeworkObject(
                due: lastWeekStart.add(Duration(days: i)),
                progress: j.toDouble(),
                shouldRemain: false,
              ),
          ],

          // [Borderline & valid] Ceates homework every day this week excluding
          // today and tomorrow
          for (int i = 2; i < 7; i++) ...<Homework>[
            for (int j = 0; j < 2; j++)
              homeworkObject(
                due: weekStart.add(Duration(days: i)),
                progress: j.toDouble(),
                shouldRemain: true,
              ),
          ],
          // [Erroneous] Creates homework every day next week
          for (int i = 0; i < 7; i++) ...<Homework>[
            for (int j = 0; j < 2; j++)
              homeworkObject(
                due: nextWeekStart.add(Duration(days: i)),
                progress: j.toDouble(),
                shouldRemain: false,
              ),
          ],
        ];

        final List<Homework> filteredHomework =
            homeworkPage.homeworkThisWeek(unfilteredHomework);

        // 10 pieces of homework due this week are provided
        expect(filteredHomework.length, equals(10));

        // Only homework that meets the test condition should remain
        expectValidHomework(filteredHomework, 'homeworkThisWeek');
      },
      // TODO fix test
      // skip: true,
    );

    test(
        'homeworkNextWeek() only returns homework due next week excluding'
        ' homework due tomorrow.', () {
      final List<Homework> unfilteredHomework = <Homework>[
        // [Erroneous] Creates homework every day this week and the first day
        // of next week as the current day is set to sunday
        for (int i = 0; i < 8; i++) ...<Homework>[
          for (int j = 0; j < 2; j++)
            homeworkObject(
              due: weekStart.add(Duration(days: i)),
              progress: j.toDouble(),
              shouldRemain: false,
            ),
        ],

        // [Borderline & valid] Creates homework every day next week
        for (int i = 1; i < 7; i++) ...<Homework>[
          for (int j = 0; j < 2; j++)
            homeworkObject(
              due: nextWeekStart.add(Duration(days: i)),
              progress: j.toDouble(),
              shouldRemain: true,
            ),
        ],
        // [Erroneous] Creates homework every day the week after next week
        for (int i = 0; i < 7; i++) ...<Homework>[
          for (int j = 0; j < 2; j++)
            homeworkObject(
              due: weekAfterNextWeekStart.add(Duration(days: i)),
              progress: j.toDouble(),
              shouldRemain: false,
            ),
        ],
      ];

      // Sets the current date to the day before the next week
      homeworkPage.now = nextWeekStart.subtract(const Duration(days: 1));

      final List<Homework> filteredHomework =
          homeworkPage.homeworkNextWeek(unfilteredHomework);

      homeworkPage.now = weekStart;

      // Only 12 pieces of homework due next week are provided
      expect(filteredHomework.length, equals(12));

      // Only homework that meets the test condition should remain
      // expectValidHomework(filteredHomework, 'homeworkNextWeek');
    });

    test('otherHomework() only returns homework due after next week.', () {
      final DateTime threeWeeksStart =
          weekAfterNextWeekStart.add(const Duration(days: 7));
      final List<Homework> unfilteredHomework = <Homework>[
        // Creates homework from the start of the week up until the day before
        // the start of the week after next week
        for (int i = 0; i < 14; i++) ...<Homework>[
          for (int j = 0; j < 2; j++)
            homeworkObject(
              due: weekStart.add(Duration(days: i)),
              progress: j.toDouble(),
              shouldRemain: false,
            ),
        ],
        // [Borderline & valid] Creates homework every for a year after next
        // week
        for (int i = 0; i < 365; i++) ...<Homework>[
          for (int j = 0; j < 2; j++)
            homeworkObject(
              due: threeWeeksStart.add(Duration(days: i)),
              progress: j.toDouble(),
              shouldRemain: true,
            ),
        ],
      ];

      final List<Homework> filteredHomework =
          homeworkPage.otherHomework(unfilteredHomework);

      // 365 pieces of homework due on or after the week after next week are
      // provided
      expect(filteredHomework.length, equals(365 * 2));

      // Only homework that meets the test condition should remain
      expectValidHomework(filteredHomework, 'otherHomework');
    });
  });
}
