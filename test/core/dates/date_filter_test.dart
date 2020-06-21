// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:cheon/core/dates/date_filter.dart';
import 'package:cheon/core/dates/date_utils.dart';

void main() {
  test(
    'isToday should return true when provided a date that is today',
    () async {
      // ARRANGE
      final datesOccuringToday = [
        DateTime.now(),
        DateTime.now().truncateToDay(),
        DateTime.now().truncateToDay().add(
              Duration(days: 1) - Duration(microseconds: 1),
            ),
      ];
      final dateFilter = DateFilter();

      // ACT
      // ASSERT
      for (DateTime date in datesOccuringToday) {
        expect(dateFilter.isToday(date), true);
      }
    },
  );

  /* test(
    'isTomorrow',
    () async {
      // ARRANGE

      // ACT

      // ASSERT
    },
  );
  test(
    'isThisWeek',
    () async {
      // ARRANGE

      // ACT

      // ASSERT
    },
  );
  test(
    'isNextWeek',
    () async {
      // ARRANGE

      // ACT

      // ASSERT
    },
  );
  test(
    'isOther',
    () async {
      // ARRANGE

      // ACT

      // ASSERT
    },
  ); */
}
