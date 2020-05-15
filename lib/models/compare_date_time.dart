import 'package:cheon/models/compare_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CompareDateTime extends CompareTime with EquatableMixin {
  /// Extend this class to compare it to a [DateTime]
  CompareDateTime(this.compareDateTime)
      : super(TimeOfDay.fromDateTime(compareDateTime));

  /// The [DateTime] represented by the child class
  final DateTime compareDateTime;

  int compareDateTimeTo(DateTime dateTime) =>
      compareDateTime.compareTo(dateTime);

  @override
  List<Object> get props => <Object>[compareDateTime];
}
