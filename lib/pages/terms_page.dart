import 'package:animations/animations.dart';
import 'package:cheon/app.dart';
import 'package:cheon/components/custom_selection_dialog.dart';
import 'package:cheon/components/empty_placeholder.dart';
import 'package:cheon/components/loading_indicator.dart';
import 'package:cheon/components/platform_date_time_picker.dart';
import 'package:cheon/models/inset_day.dart';
import 'package:cheon/models/term.dart';
import 'package:cheon/models/year.dart';
import 'package:cheon/pages/add_inset_day_page.dart';
import 'package:cheon/pages/add_year_page.dart';
import 'package:cheon/view_models/preferences_view_model.dart';
import 'package:cheon/view_models/year_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Creates a page containing a list of academic terms and the option to add
/// holidays and academic years
class TermsPage extends StatelessWidget {
  const TermsPage({Key key}) : super(key: key);

  static const String routeName = '/terms';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms')),
      body: _TermsBody(),
    );
  }
}

class _TermsBody extends StatefulWidget {
  @override
  __TermsBodyState createState() => __TermsBodyState();
}

class __TermsBodyState extends State<_TermsBody> {
  RangeValues termRange;

  void hideHolidayLessons(BuildContext context, bool hide) {
    Provider.of<Preferences>(context, listen: false).hideHolidayLessons = hide;
  }

  Future<void> selectYear(BuildContext context, Year selectedYear) async {
    final YearVM yearVM = context.read<YearVM>();
    final Year year = await showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return StreamBuilder<List<Year>>(
          stream: yearVM.yearListStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Year>> snapshot,
          ) {
            final List<Year> years = snapshot.data ?? <Year>[];
            // TODO add option to delete year
            return CustomSelectionDialog(
              title: 'Academic Years',
              action: CustomSelectionDialogAction(
                tooltip: 'Add Year',
                onPressed: () =>
                    Navigator.pushNamed(context, AddYearPage.routeName),
              ),
              items: years.map((Year year) {
                final String yearStartStrig = MaterialLocalizations.of(context)
                    .formatMediumDate(year.start);
                final String yearEndString = MaterialLocalizations.of(context)
                    .formatMediumDate(year.end);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(App.borderRadius),
                      side: selectedYear == year
                          ? BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : BorderSide.none,
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$yearStartStrig – $yearEndString',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, year),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
    if (year != null) {
      await yearVM.updateYear(year, lastSelected: DateTime.now());
    }
  }

  void selectYearStart(BuildContext context, {@required Year currentYear}) {
    final YearVM yearVM = context.read<YearVM>();
    showPlatformDatePicker(
      context: context,
      initialDate: currentYear.start,
      minimunDate: currentYear.start.subtract(const Duration(days: 365 * 5)),
    ).listen((DateTime date) {
      yearVM.updateYear(currentYear, start: date);
    });
  }

  void selectYearEnd(BuildContext context, {@required Year currentYear}) {
    final YearVM yearVM = context.read<YearVM>();
    showPlatformDatePicker(
      context: context,
      initialDate: currentYear.end,
      maximumDate: currentYear.end.add(const Duration(days: 365 * 5)),
    ).listen((DateTime date) {
      yearVM.updateYear(currentYear, end: date);
    });
  }

  Future<void> updateTermRange(
    RangeValues termRange, {
    @required int startTerm,
    @required int endTerm,
    @required List<Term> terms,
    // Needed to add terms when none exist.
    @required Year year,
  }) async {
    if (termRange == this.termRange) return;
    this.termRange = termRange;
    final YearVM yearVM = context.read<YearVM>();

    print('Start: $startTerm-${termRange.start}');
    print('End: $endTerm-${termRange.end}');

    const Duration holidayDuration = Duration(days: 11);
    // Assumes 7 weeks in a term by default
    const Duration termDuration = Duration(days: 7 * 7);
    if (termRange.start.toInt() != startTerm) {
      if (termRange.start.toInt() > startTerm) {
        // Delete terms that are smaller than the new term start
        await yearVM.deleteTerm(terms.first);
      } else {
        // Create a new term before the first term
        final Term first = terms.first;
        if (terms
            .where((Term term) => term.term == first.term - 1)
            .isNotEmpty) {
          return;
        }

        final DateTime end = first.start.subtract(holidayDuration);
        final DateTime start = end.subtract(termDuration);
        await yearVM.addTerm(
          term: first.term - 1,
          start: start,
          end: end,
          year: year,
        );
      }
    } else if (termRange.end.toInt() != endTerm) {
      if (termRange.end.toInt() > endTerm) {
        // Create a new term after the last term

        final Term last = terms.last;
        if (terms.where((Term term) => term.term == last.term + 1).isNotEmpty) {
          return;
        }
        final DateTime start = last.end.add(holidayDuration);
        // Assumes 7 weeks in a term by default
        final DateTime end = start.add(termDuration);
        await yearVM.addTerm(
          term: last.term + 1,
          start: start,
          end: end,
          year: year,
        );
      } else if (termRange.end.toInt() < endTerm) {
        // Delete terms that are greater than the new term end
        await yearVM.deleteTerm(terms.last);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final YearVM yearVM = Provider.of<YearVM>(context, listen: false);
    return StreamBuilder<Year>(
        stream: yearVM.activeYearStream,
        builder: (BuildContext context, AsyncSnapshot<Year> snapshot) {
          final Year year = snapshot.data;

          return ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          title: Text(
                            year != null
                                ? '${year.start.year}-${year.end.year}'
                                : 'Academic Year',
                          ),
                          trailing: Icon(FontAwesomeIcons.chevronDown),
                          onTap: () => selectYear(context, year),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: const Text('Start'),
                                trailing: year != null
                                    ? Text(MaterialLocalizations.of(context)
                                        .formatMediumDate(year.start))
                                    : null,
                                onTap: year != null
                                    ? () => selectYearStart(context,
                                        currentYear: year)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: const Text('End'),
                                trailing: year != null
                                    ? Text(MaterialLocalizations.of(context)
                                        .formatMediumDate(year.end))
                                    : null,
                                onTap: year != null
                                    ? () => selectYearEnd(context,
                                        currentYear: year)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      /* Card(
                        child: SwitchListTile.adaptive(
                          title: const Text('Only show lessons in term time.'),
                          subtitle: const Text(
                            'Hides lessons from the timeline when you are on '
                            'holiday',
                          ),
                          value: Provider.of<Preferences>(context, listen: true)
                              .hideHolidayLessons,
                          onChanged: (bool value) =>
                              hideHolidayLessons(context, value),
                        ),
                      ), */
                    ],
                  )),
              const SizedBox(height: 8),
              StreamBuilder<List<Term>>(
                stream: yearVM.termListStream,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Term>> snapshot) {
                  if (snapshot.hasData) {
                    final List<Term> terms = snapshot.data ?? <Term>[];
                    final int startTerm =
                        terms.isNotEmpty ? terms.first.term : 0;
                    final int endTerm = terms.isNotEmpty ? terms.last.term : 0;
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Term range'),
                              Text('Terms $startTerm to $endTerm'),
                            ],
                          ),
                        ),
                        // TODO improve behaviour of this
                        RangeSlider(
                          onChanged: (RangeValues termRange) => updateTermRange(
                            termRange,
                            startTerm: startTerm,
                            endTerm: endTerm,
                            terms: terms,
                            year: year,
                          ),
                          values: RangeValues(
                            startTerm.toDouble(),
                            endTerm.toDouble(),
                          ),
                          divisions: 9,
                          min: 1,
                          max: 10,
                          labels: RangeLabels(
                            'Term $startTerm',
                            'Term $endTerm',
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const Divider(height: 0),
              StreamBuilder<List<Term>>(
                stream: yearVM.termListStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Term>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final List<Term> terms = snapshot.data;
                    if (terms.isEmpty) {
                      return const EmptyPlaceholder(
                        text: 'No terms for this year.',
                      );
                    } else {
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: terms.length,
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 84),
                        itemBuilder: (BuildContext context, int index) {
                          return _TermCard(term: terms[index]);
                        },
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingIndicator());
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        });
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({Key key, @required this.term})
      : assert(term != null),
        super(key: key);

  final Term term;

  void addInsetDay(BuildContext context) {
    Navigator.pushNamed(context, AddInsetDayPage.routeName, arguments: term);
  }

  void changeTermStart(BuildContext context) {
    final YearVM yearVM = context.read<YearVM>();

    showPlatformDatePicker(context: context, initialDate: term.start)
        .listen((DateTime date) => yearVM.updateTerm(term, start: date));
  }

  void changeTermEnd(BuildContext context) {
    final YearVM yearVM = context.read<YearVM>();

    showPlatformDatePicker(context: context, initialDate: term.end)
        .listen((DateTime date) => yearVM.updateTerm(term, end: date));
  }

  Future<void> deleteInsetDay(BuildContext context, InsetDay insetDay) {
    final YearVM yearVM = context.read<YearVM>();
    return yearVM.deleteInsetDay(insetDay);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<List<InsetDay>> insetDayStream =
        context.select<YearVM, Stream<List<InsetDay>>>(
      (YearVM vm) => vm.insetDayListFromTerm(term),
    );
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Term ${term.term}'),
            contentPadding: const EdgeInsets.only(left: 16, right: 8),
            trailing: FlatButton(
              textTheme: ButtonTextTheme.accent,
              child: const Text('ADD INSET DAY'),
              onPressed: () => addInsetDay(context),
            ),
          ),
          // Inset days
          StreamBuilder<List<InsetDay>>(
            stream: insetDayStream,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<InsetDay>> snapshot,
            ) {
              final List<InsetDay> insetDays = snapshot.data ?? <InsetDay>[];
              if (insetDays.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Inset days',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 0),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: insetDays.length,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (BuildContext context, int index) {
                        final InsetDay insetDay = insetDays[index];
                        return ListTile(
                          title: Text(MaterialLocalizations.of(context)
                              .formatMediumDate(insetDay.date)),
                          contentPadding: const EdgeInsets.only(
                            top: 0,
                            bottom: 0,
                            right: 8,
                            left: 16,
                          ),
                          trailing: IconButton(
                            icon: Icon(FontAwesomeIcons.trashAlt),
                            iconSize: 20,
                            onPressed: () => deleteInsetDay(context, insetDay),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(height: 0),
                    )
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const Divider(height: 0),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(term.start),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () => changeTermStart(context),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(term.end),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () => changeTermEnd(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
