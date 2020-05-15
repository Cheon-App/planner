import 'package:cheon/database/daos/year_dao.dart';
import 'package:cheon/database/database.dart';
import 'package:cheon/models/inset_day.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/repositories/timetable_repository.dart';
import 'package:cheon/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class YearRepository {
  YearRepository._internal() {
    _dao.activeYearStream().listen(_activeYearSubject.add);
    _dao.yearListStream().listen(_yearListSubject.add);
    _dao.termListStream().listen(_termListSubject.add);
    _dao.insetDayListStream().listen(_insetDayListSubject.add);
  }

  static YearRepository get instance => _singleton;

  static final YearRepository _singleton = YearRepository._internal();
  final TimetableRepository _timetableRepository = TimetableRepository.instance;

  final YearDao _dao = Database.instance.yearDao;

  final BehaviorSubject<Year> _activeYearSubject = BehaviorSubject<Year>();
  Stream<Year> get activeYearStream => _activeYearSubject.stream;

  final BehaviorSubject<List<Year>> _yearListSubject =
      BehaviorSubject<List<Year>>();
  Stream<List<Year>> get yearListStream => _yearListSubject.stream;

  final BehaviorSubject<List<Term>> _termListSubject =
      BehaviorSubject<List<Term>>();
  Stream<List<Term>> get termListStream => _termListSubject.stream;

  final BehaviorSubject<List<InsetDay>> _insetDayListSubject =
      BehaviorSubject<List<InsetDay>>();
  Stream<List<InsetDay>> get insetDayListStream => _insetDayListSubject.stream;

  Future<Year> addYear({
    @required DateTime start,
    @required DateTime end,
    @required bool createTerms,
  }) async {
    final Year year = await _dao.addYear(
      start: strippedDateTime(start),
      end: strippedDateTime(end),
      createTerms: createTerms,
    );
    await _timetableRepository.addTimetable(1, year);
    return year;
  }

  Future<void> updateYear(
    Year year, {
    @required DateTime start,
    @required DateTime end,
    @required DateTime lastSelected,
  }) =>
      _dao.updateYear(
        year,
        start: start != null ? strippedDateTime(start) : null,
        end: end != null ? strippedDateTime(end) : null,
        lastSelected: lastSelected,
      );

  Future<void> deleteYear(Year year) => _dao.deleteYear(year);

  Future<void> addTerm({
    @required int term,
    @required DateTime start,
    @required DateTime end,
    @required Year year,
  }) =>
      _dao.addTerm(
        term: term,
        start: strippedDateTime(start),
        end: strippedDateTime(end),
        year: year,
      );

  Future<void> updateTerm(
    Term term, {
    DateTime start,
    DateTime end,
    int termNo,
  }) =>
      _dao.updateTerm(
        term,
        start: start != null ? strippedDateTime(start) : null,
        end: end != null ? strippedDateTime(end) : null,
        termNo: termNo,
      );

  Future<void> deleteTerm(Term term) => _dao.deleteTerm(term);

  Future<void> addInsetDay(Term term, {@required DateTime date}) =>
      _dao.addInsetDay(term, date: date);

  Stream<List<InsetDay>> insetDayListFromTerm(Term term) =>
      _dao.insetDayListFromTerm(term);

  Future<void> deleteInsetDay(InsetDay insetDay) =>
      _dao.deleteInsetDay(insetDay);

  Future<void> init() async {
    Year year = await _dao.activeYear();
    if (year == null) {
      print('Creating an initial year');
      // Create a year and a timetable
      DateTime start;
      DateTime end;
      final DateTime now = DateTime.now();
      if (now.month <= DateTime.july) {
        start = DateTime(now.year - 1, DateTime.september, 1);
        end = DateTime(now.year, DateTime.july, 31);
      } else {
        start = DateTime(now.year, DateTime.september, 1);
        end = DateTime(now.year + 1, DateTime.july, 31);
      }

      print('Adding year: $start - $end');
      // Add a year
      year = await addYear(start: start, end: end, createTerms: true);

      // Adds 5 default lesson times.
      for (int i = 1; i <= 5; i++) {
        await _timetableRepository.addLessonTime(
            i, DateTime(0, 0, 0, 8 + i, 0));
      }
    }
  }
}
