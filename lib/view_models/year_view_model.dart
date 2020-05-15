// import 'package:cheon/database/tables.dart' as tables;
import 'package:cheon/models/term.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/models/inset_day.dart';
import 'package:cheon/repositories/year_repository.dart';
import 'package:meta/meta.dart';

class YearVM {
  final YearRepository _yearRepository = YearRepository.instance;

  /// A stream providing a list of [Year]s
  Stream<List<Year>> get yearListStream => _yearRepository.yearListStream;

  /// A stream providing the year currently being used
  Stream<Year> get activeYearStream => _yearRepository.activeYearStream;

  /// A stream providing a list of terms
  Stream<List<Term>> get termListStream => _yearRepository.termListStream;

  /// Creates a year
  Future<void> addYear({
    @required DateTime start,
    @required DateTime end,
    @required bool createTerms,
  }) =>
      _yearRepository.addYear(
        start: start,
        end: end,
        createTerms: createTerms,
      );

  /// Updates a year
  Future<void> updateYear(
    Year year, {
    DateTime start,
    DateTime end,
    DateTime lastSelected,
  }) =>
      _yearRepository.updateYear(
        year,
        start: start,
        end: end,
        lastSelected: lastSelected,
      );

  /// Removes a year
  Future<void> deleteYear(Year year) => _yearRepository.deleteYear(year);

  /// Creates an academic term for an academic year
  Future<void> addTerm({
    @required int term,
    @required DateTime start,
    @required DateTime end,
    @required Year year,
  }) =>
      _yearRepository.addTerm(term: term, start: start, end: end, year: year);

  /// Updates a term
  Future<void> updateTerm(
    Term term, {
    DateTime start,
    DateTime end,
    int termNo,
  }) =>
      _yearRepository.updateTerm(
        term,
        start: start,
        end: end,
        termNo: termNo,
      );

  /// Deletes a term
  Future<void> deleteTerm(Term term) => _yearRepository.deleteTerm(term);

  /// Creates an inset day
  Future<void> addInsetDay(Term term, {DateTime date}) =>
      _yearRepository.addInsetDay(term, date: date);

  /// A stream providing a list of inset days for a term
  Stream<List<InsetDay>> insetDayListFromTerm(Term term) =>
      _yearRepository.insetDayListFromTerm(term);

  /// Deletes an inset day
  Future<void> deleteInsetDay(InsetDay insetDay) =>
      _yearRepository.deleteInsetDay(insetDay);

  void dispose() {}
}
