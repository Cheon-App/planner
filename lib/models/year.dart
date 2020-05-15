import 'package:cheon/database/database.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Year extends Equatable {
  /// Represents an academic year
  const Year({
    @required this.id,
    @required this.start,
    @required this.end,
  })  : assert(id != null),
        assert(start != null),
        assert(end != null);

  factory Year.fromDBModel(YearModel yearModel) {
    return Year(
      id: yearModel.id,
      start: yearModel.start,
      end: yearModel.end,
    );
  }

  /// A UUID identifier for the year
  final String id;

  /// The start date of the year
  final DateTime start;

  /// The end date of the year
  final DateTime end;

  @override
  List<Object> get props => <Object>[id];
}
