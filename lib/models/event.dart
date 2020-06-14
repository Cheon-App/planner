// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:cheon/models/compare_time.dart';

@immutable
class Event extends CompareTime {
  /// The base class for a physical event
  Event({
    @required this.start,
    @required this.end,
    @required this.title,
    this.description,
    this.location,
    @required this.id,
  })  : assert(start != null),
        assert(end != null),
        assert(!start.isAtSameMomentAs(end)),
        assert(title != null),
        super(TimeOfDay.fromDateTime(start));

  /// A UUID identifier for the event
  final String id;

  /// The start date and time of the event
  final DateTime start;

  /// The end date and time of the event
  final DateTime end;

  /// The event title
  final String title;

  /// The event description
  final String description;

  /// The event location
  final String location;

  @override
  List<Object> get props => <Object>[id];
}
