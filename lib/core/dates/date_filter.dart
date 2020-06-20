// Project imports:
import 'package:cheon/utils/date_utils.dart';

// TODO test this
class DateFilter {
  final DateTime now = DateTime.now().truncateToDay();

  bool isToday(DateTime date) => date.truncateToDay().isAtSameMomentAs(now);

  bool isTomorrow(DateTime date) =>
      now.nextDay().isAtSameMomentAs(date.truncateToDay());

  bool isThisWeek(DateTime date) {
    final DateTime weekStart = now.startOfWeek();
    final DateTime weekEnd = weekStart.add7Days();
    final DateTime twoDays = now.addDays(2);

    return (date.isAfter(twoDays) || date.isAtSameMomentAs(twoDays)) &&
        date.isBefore(weekEnd);
  }

  bool isNextWeek(DateTime date) {
    final bool isSunday = now.weekday == DateTime.sunday;
    final DateTime nextWeekStart = now.startOfWeek().add7Days();

    final DateTime nextWeekEnd = nextWeekStart.add7Days();

    final DateTime nextWeekStartAdjusted =
        nextWeekStart.addDays(isSunday ? 1 : 0);

    return (date.isAfter(nextWeekStartAdjusted) ||
            date.isAtSameMomentAs(nextWeekStartAdjusted)) &&
        date.isBefore(nextWeekEnd);
  }

  bool isOther(DateTime date) {
    final DateTime nextWeekEnd = now //
        .addDays(DateTime.sunday - now.weekday + 1)
        .add7Days();

    return date.isAfter(nextWeekEnd) || date.isAtSameMomentAs(nextWeekEnd);
  }
}
