import 'package:cheon/database/database.dart';
import 'package:cheon/models/term.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class InsetDay extends Equatable {
  /// Represents an inset day i.e. a day where school and thus lessons do not
  /// take place
  const InsetDay({
    @required this.id,
    @required this.date,
    @required this.term,
  })  : assert(id != null),
        assert(date != null),
        assert(term != null);

  factory InsetDay.fromDBModel({
    @required InsetDayModel insetDayModel,
    @required Term term,
  }) {
    return InsetDay(
      id: insetDayModel.id,
      date: insetDayModel.date,
      term: term,
    );
  }

  /// A UUID identifier for the inset day
  final String id;

  /// The date of the inset day
  final DateTime date;

  /// The term the inset day belongs to
  final Term term;

  @override
  List<Object> get props => <Object>[id];
}
