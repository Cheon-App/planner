// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

extension ContextTheme on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

Brightness invertedBrigntness(Brightness brightness) =>
    brightness == Brightness.light ? Brightness.dark : Brightness.light;

/// Converts a [DateTime] to a string in the form 'day month'
String dateTimeToDayMonth(DateTime dateTime) {
  final String day = '${dateTime.day}';
  final String month = monthToShortString(dateTime.month);
  return '$day $month';
}

/// Returns a [DateTime] truncated to a day
DateTime strippedDateTime(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);

/// Generates an Universally Unique identifier
String generateUUID() => Uuid().v4();

/// Adds a leading '0' to a string if it's one digit.
/// Useful for formatting dates.
String padString(String string) {
  return string.padLeft(2, '0');
}

/// Return true if the device is running android or fuchsia.
bool isMaterial(BuildContext context) {
  bool isMaterial;
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      isMaterial = false;
      break;
    default:
      isMaterial = true;
  }
  return isMaterial;
}

/// Converts a [DateTime] into a formatted timestamp e.g. 3 days ago.
String fuzzyTimestamp(DateTime dateTime) {
  timeago.setLocaleMessages('en_future', TimeAheadMessages());
  return timeago.format(dateTime, allowFromNow: true, locale: 'en_future');
}

/// The locale override for the timeago package that enables timestamps in the
/// future.
class TimeAheadMessages extends timeago.EnMessages {
  @override
  String prefixFromNow() => 'In';
  @override
  String suffixFromNow() => '';
}

/// An extension method added to [TimeOfDay] at compile time.
/// Enables [TimeOfDay] to be converted to and from json.
extension SerializedTimeOfDay on TimeOfDay {
  String toJson() => jsonEncode(
        <String, String>{'hour': '$hour', 'minute': '$minute'},
      );

  static TimeOfDay fromJson(String json) {
    final Map<String, String> map = Map<String, String>.from(jsonDecode(json));
    return TimeOfDay(
      hour: int.parse(map['hour']),
      minute: int.parse(map['minute']),
    );
  }
}

extension TimeOfDayComparison on TimeOfDay {
  bool isBefore(TimeOfDay timeOfDay) =>
      !isAfter(timeOfDay) && !isAfterOrSameAs(timeOfDay);

  bool isAfter(TimeOfDay timeOfDay) {
    if (hour > timeOfDay.hour) {
      return true;
    } else if (hour == timeOfDay.hour && minute > timeOfDay.minute) {
      return true;
    } else {
      return false;
    }
  }

  bool isBeforeOrSameAs(TimeOfDay timeOfDay) =>
      isBefore(timeOfDay) || isSameTimeAs(timeOfDay);

  bool isAfterOrSameAs(TimeOfDay timeOfDay) =>
      isAfter(timeOfDay) || isSameTimeAs(timeOfDay);

  bool isSameTimeAs(TimeOfDay timeOfDay) => timeOfDay == this;
}

final numberRegExp = RegExp('1|2|3|4|5|6|7|8|9|0');
final numberInputFormatter = WhitelistingTextInputFormatter(numberRegExp);

/// Converts a DateTime.day value to a short string e.g. 1 -> Mon
String dayToShortString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Mon';
      break;
    case DateTime.tuesday:
      return 'Tue';
      break;
    case DateTime.wednesday:
      return 'Wed';
      break;
    case DateTime.thursday:
      return 'Thurs';
      break;
    case DateTime.friday:
      return 'Fri';
      break;
    case DateTime.saturday:
      return 'Sat';
      break;
    case DateTime.sunday:
      return 'Sun';
      break;
    default:
      return null;
  }
}

/// Converts a DateTime.weekday value to a full length string e.g. 1 -> Monday
String dayToString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Monday';
      break;
    case DateTime.tuesday:
      return 'Tuesday';
      break;
    case DateTime.wednesday:
      return 'Wednesday';
      break;
    case DateTime.thursday:
      return 'Thursday';
      break;
    case DateTime.friday:
      return 'Friday';
      break;
    case DateTime.saturday:
      return 'Saturday';
      break;
    case DateTime.sunday:
      return 'Sunday';
      break;
    default:
      return null;
  }
}

/// Converts a DateTime.month value to a short string e.g. 1 -> Jan
String monthToShortString(int month) {
  switch (month) {
    case DateTime.january:
      return 'Jan';
      break;
    case DateTime.february:
      return 'Feb';
      break;
    case DateTime.march:
      return 'Mar';
      break;
    case DateTime.april:
      return 'Apr';
      break;
    case DateTime.may:
      return 'May';
      break;
    case DateTime.june:
      return 'Jun';
      break;
    case DateTime.july:
      return 'Jul';
      break;
    case DateTime.august:
      return 'Aug';
      break;
    case DateTime.september:
      return 'Sep';
      break;
    case DateTime.october:
      return 'Oct';
      break;
    case DateTime.november:
      return 'Nov';
      break;
    case DateTime.december:
      return 'Dec';
      break;
    default:
      return null;
  }
}

/// Converts a DateTime.month value to a full length string e.g. 1 -> January
String monthToString(int month) {
  switch (month) {
    case DateTime.january:
      return 'January';
      break;
    case DateTime.february:
      return 'February';
      break;
    case DateTime.march:
      return 'March';
      break;
    case DateTime.april:
      return 'April';
      break;
    case DateTime.may:
      return 'May';
      break;
    case DateTime.june:
      return 'June';
      break;
    case DateTime.july:
      return 'July';
      break;
    case DateTime.august:
      return 'August';
      break;
    case DateTime.september:
      return 'September';
      break;
    case DateTime.october:
      return 'October';
      break;
    case DateTime.november:
      return 'November';
      break;
    case DateTime.december:
      return 'December';
      break;
    default:
      return null;
  }
}
