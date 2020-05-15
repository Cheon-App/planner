import 'package:cheon/database/database.dart';
import 'package:cheon/models/year.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Term extends Equatable {
  /// Represents a school term i.e. a period of time where lessons take place
  const Term({
    @required this.id,
    @required this.year,
    @required this.start,
    @required this.end,
    @required this.term,
  })  : assert(id != null),
        assert(year != null),
        assert(start != null),
        assert(end != null),
        assert(term != null);

  factory Term.fromDBModel(TermModel termModel, Year year) {
    return Term(
      id: termModel.id,
      start: termModel.start,
      end: termModel.end,
      year: year,
      term: termModel.term,
    );
  }

  /// A UUID identifier for the term
  final String id;

  /// The year the term belongs to
  final Year year;

  /// The start date of the term
  final DateTime start;

  /// The end date of the term
  final DateTime end;

  /// An index used to order terms
  final int term;

  @override
  List<Object> get props => <Object>[id];
}
