// Package imports:
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'calendar.g.dart';

@immutable
@JsonSerializable()
class Calendar extends Equatable {
  /// A calendar imported from the local device
  const Calendar({
    @required this.id,
    @required this.name,
    @required this.accountName,
    @required this.accountType,
  })  : assert(id != null),
        assert(name != null);

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarToJson(this);

  /// The device-specific identifier for the calendar
  final String id;

  /// The name of the calendar
  final String name;

  /// The name or email the calendar belongs to
  final String accountName;

  /// A domain for the calendar e.g. com.google
  final String accountType;

  @override
  List<Object> get props => <Object>[id];

  @override
  bool get stringify => true;
}
