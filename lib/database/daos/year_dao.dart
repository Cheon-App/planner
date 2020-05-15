import 'package:cheon/database/database.dart';
import 'package:cheon/database/tables.dart' as tables;
import 'package:cheon/database/converters/uuid_converter.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/models/inset_day.dart';
import 'package:cheon/utils.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

part 'year_dao.g.dart';

@UseDao(tables: <Type>[tables.Years, tables.Terms, tables.InsetDay])
class YearDao extends DatabaseAccessor<Database> with _$YearDaoMixin {
  YearDao(Database db) : super(db);

  Stream<List<Year>> yearListStream() {
    return select(years).watch().map((List<YearModel> yearList) {
      return yearList.map((YearModel year) => Year.fromDBModel(year)).toList();
    });
  }

  Stream<YearModel> _activeYearStream() {
    return (select(years)
          ..orderBy(<OrderingTerm Function($YearsTable)>[
            ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
          ])
          ..limit(1))
        .watchSingle();
  }

  Stream<List<Term>> termListStream() {
    return _activeYearStream().switchMap((YearModel yearModel) {
      return (select(terms)
            ..where(
              ($TermsTable table) => table.yearId.equals(
                uuidToUint8List(yearModel.id),
              ),
            )
            ..orderBy(
              <OrderingTerm Function($TermsTable)>[
                ($TermsTable table) => OrderingTerm(
                      expression: table.term,
                      mode: OrderingMode.asc,
                    )
              ],
            ))
          .map(
            (TermModel termModel) => Term.fromDBModel(
              termModel,
              Year.fromDBModel(yearModel),
            ),
          )
          .watch();
    });
  }

  Stream<List<InsetDay>> insetDayListStream() {
    return _activeYearStream().switchMap(
      (YearModel yearModel) {
        // Selects inset days that belong to the provided year
        return select(insetDay).join(<Join<Table, DataClass>>[
          innerJoin(terms, terms.id.equalsExp(insetDay.termId)),
          innerJoin(years, years.id.equals(uuidToUint8List(yearModel.id)))
        ]).map((TypedResult row) {
          final InsetDayModel insetDayModel = row.readTable(insetDay);
          final TermModel termModel = row.readTable(terms);
          return InsetDay.fromDBModel(
            insetDayModel: insetDayModel,
            term: Term.fromDBModel(termModel, Year.fromDBModel(yearModel)),
          );
        }).watch();
      },
    );
  }

  Future<Year> activeYear() async {
    final YearModel year = await (select(years)
          ..orderBy(
            <OrderingTerm Function($YearsTable)>[
              ($YearsTable table) => OrderingTerm.desc(table.lastSelected),
            ],
          )
          ..limit(1))
        .getSingle();

    return year != null ? Year.fromDBModel(year) : null;
  }

  Stream<Year> activeYearStream() {
    return _activeYearStream()
        .map((YearModel yearModel) => Year.fromDBModel(yearModel));
  }

  Future<Year> addYear({
    @required DateTime start,
    @required DateTime end,
    @required bool createTerms,
  }) async {
    final YearModel yearModel = YearModel(
      id: generateUUID(),
      start: start,
      end: end,
      lastSelected: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await into(years).insert(yearModel);
    final Year year = Year.fromDBModel(yearModel);

    if (createTerms) {
      // Create 6 terms with estimated start/end dates
      final int yearInt = year.start.year;
      // TODO consider adding terms in batch
      await addTerm(
        term: 1,
        start: year.start,
        end: DateTime(yearInt, 10, 18),
        year: year,
      );
      await addTerm(
        term: 2,
        start: DateTime(yearInt, 10, 28),
        end: DateTime(yearInt, 12, 19),
        year: year,
      );
      await addTerm(
        term: 3,
        start: DateTime(yearInt + 1, 1, 6),
        end: DateTime(yearInt + 1, 2, 14),
        year: year,
      );
      await addTerm(
        term: 4,
        start: DateTime(yearInt + 1, 2, 24),
        end: DateTime(yearInt + 1, 4, 3),
        year: year,
      );
      await addTerm(
        term: 5,
        start: DateTime(yearInt + 1, 4, 20),
        end: DateTime(yearInt + 1, 5, 22),
        year: year,
      );
      await addTerm(
        term: 6,
        start: DateTime(yearInt + 1, 6, 1),
        end: DateTime(yearInt + 1, 7, 17),
        year: year,
      );
    } else {
      await addTerm(
        term: 1,
        start: year.start,
        end: year.start.add(const Duration(days: 7 * 6)),
        year: year,
      );
    }
    return year;
  }

  Future<void> updateYear(
    Year year, {
    DateTime start,
    DateTime end,
    DateTime lastSelected,
  }) {
    final YearsCompanion companion = YearsCompanion(
      id: Value<String>(year.id),
      start: start != null
          ? Value<DateTime>(start)
          : const Value<DateTime>.absent(),
      end: end != null ? Value<DateTime>(end) : const Value<DateTime>.absent(),
      lastSelected: lastSelected != null
          ? Value<DateTime>(lastSelected)
          : const Value<DateTime>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(years)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteYear(Year year) {
    final YearsCompanion companion = YearsCompanion(id: Value<String>(year.id));
    return (delete(years)..whereSamePrimaryKey(companion)).go();
  }

  Future<void> addTerm({
    @required int term,
    @required DateTime start,
    @required DateTime end,
    @required Year year,
  }) {
    return into(terms).insert(
      TermModel(
        id: generateUUID(),
        yearId: year.id,
        start: start,
        end: end,
        term: term,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  Future<void> updateTerm(
    Term term, {
    DateTime start,
    DateTime end,
    int termNo,
  }) {
    final TermsCompanion companion = TermsCompanion(
      id: Value<String>(term.id),
      start: start != null
          ? Value<DateTime>(start)
          : const Value<DateTime>.absent(),
      end: end != null ? Value<DateTime>(end) : const Value<DateTime>.absent(),
      term: termNo != null ? Value<int>(termNo) : const Value<int>.absent(),
      lastUpdated: Value<DateTime>(DateTime.now()),
    );
    return (update(terms)..whereSamePrimaryKey(companion)).write(companion);
  }

  Future<void> deleteTerm(Term term) {
    final TermsCompanion companion = TermsCompanion(id: Value<String>(term.id));
    return (delete(terms)..whereSamePrimaryKey(companion)).go();
  }

  Future<void> addInsetDay(Term term, {@required DateTime date}) {
    return into(insetDay).insert(InsetDayModel(
      id: generateUUID(),
      date: date,
      termId: term.id,
      lastUpdated: DateTime.now(),
    ));
  }

  Stream<List<InsetDay>> insetDayListFromTerm(Term term) {
    return (select(insetDay)
          ..where(
            ($InsetDayTable t) => t.termId.equals(uuidToUint8List(term.id)),
          )
          ..orderBy(
            <OrderingTerm Function($InsetDayTable)>[
              ($InsetDayTable table) => OrderingTerm.asc(table.date),
            ],
          ))
        .watch()
        .map(
          (List<InsetDayModel> insetDayModelList) => insetDayModelList
              .map(
                (InsetDayModel insetDayModel) => InsetDay.fromDBModel(
                    insetDayModel: insetDayModel, term: term),
              )
              .toList(),
        );
  }

  Future<void> deleteInsetDay(InsetDay insetDay) {
    final InsetDayCompanion companion =
        InsetDayCompanion(id: Value<String>(insetDay.id));
    return (delete(this.insetDay)..whereSamePrimaryKey(companion)).go();
  }
}
