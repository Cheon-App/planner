// Flutter imports:
import 'package:flutter/material.dart';

extension DateUtils on DateTime {
  DateTime addDays(int days) => add(Duration(days: days));

  DateTime withTime(TimeOfDay time) => dateTimeWithTimeOfDay(this, time);

  TimeOfDay get time => TimeOfDay.fromDateTime(this);

  /// Returns a [DateTime] matching the start of the week i.e. 00:00 on Monday.
  DateTime startOfWeek() {
    final int weekday = this.weekday;
    if (weekday == DateTime.monday) {
      return this;
    } else {
      return subtract(Duration(days: weekday - 1));
    }
  }

  DateTime nextDay() => addDays(1);
  DateTime add7Days() => addDays(7);

  /// Returns a new [DateTime] with precision truncated to a day.
  /// Useful for comparing dates where the time is irrelevant
  DateTime truncateToDay() => DateTime(year, month, day);

  /// Returns a [DateTime] with the hour and minute provided by [timeOfDay]
  @visibleForTesting
  DateTime dateTimeWithTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
}
