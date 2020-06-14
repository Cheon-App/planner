// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';

abstract class CompareTime with EquatableMixin {
  CompareTime(this.compareTime) : assert(compareTime != null);

  final TimeOfDay compareTime;

  /// Compares this CompareTime object to [timeOfDay], returning zero if they
  /// are at the same time.
  ///
  /// Returns a negative value if this CompareTime is before [timeOfDay] or a
  /// positive value otherwise.
  int compareTimeTo(TimeOfDay timeOfDay) {
    if (compareTime == timeOfDay) return 0;
    if (compareTime.hour == timeOfDay.hour) {
      if (compareTime.minute < timeOfDay.minute) {
        return -1;
      } else {
        return 1;
      }
    }
    if (compareTime.hour < timeOfDay.hour) {
      return -1;
    } else {
      return 1;
    }
  }
}
