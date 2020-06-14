// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/models/compare_date_time.dart';

@immutable
class CalendarEvent extends CompareDateTime {
  /// An event impored from or created for a traditional calendar app
  CalendarEvent({
    @required this.eventId,
    @required this.calendarId,
    @required this.start,
    @required this.end,
    @required this.title,
    @required this.description,
    @required this.location,
  })  : assert(eventId != null),
        assert(calendarId != null),
        assert(start != null),
        assert(end != null),
        assert(title != null),
        assert(description != null),
        assert(location != null),
        super(start);

  /// A unique event identifier
  final String eventId;

  /// A device-unique calendar identifier
  final String calendarId;

  /// The date and time that the event starts at
  final DateTime start;

  /// The date and time that the event ends at
  final DateTime end;

  /// The event title
  final String title;

  /// The event description, likely in html
  final String description;

  /// The physical location the event occurs in
  final String location;

  // attendees, reminders, uri, all day

  @override
  List<Object> get props => <Object>[eventId, calendarId];
}
