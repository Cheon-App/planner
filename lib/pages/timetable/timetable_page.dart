import 'package:animations/animations.dart';
import 'package:cheon/app.dart';
import 'package:cheon/components/custom_selection_dialog.dart';
import 'package:cheon/components/error_message.dart';
import 'package:cheon/components/loading_indicator.dart';
import 'package:cheon/components/menu_button.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/models/timetable_position.dart';
import 'package:cheon/pages/add_lesson/add_lesson_page.dart';
import 'package:cheon/pages/timetable/timetable_settings_page.dart';
import 'package:cheon/pages/view_lesson/view_lesson_page.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/timetable_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Creates a page used to view and edit a lesson timetable
class TimetablePage extends StatefulWidget {
  const TimetablePage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/timetable';
  final bool inHomePage;

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void openTimetableSettings() {
    Navigator.pushNamed(context, TimetableSettingsPage.routeName);
  }

  Future<void> selectTimetable(Timetable selectedTimetable) async {
    final TimetableVM timetableVM = context.read<TimetableVM>();
    final Timetable timetable = await showModal<Timetable>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return StreamBuilder<List<Timetable>>(
          stream: timetableVM.timetableListStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Timetable>> snapshot,
          ) {
            final List<Timetable> timetables = snapshot.data ?? <Timetable>[];
            return CustomSelectionDialog(
              title: 'Set timetable',
              items: timetables
                  .map(
                    (Timetable timetable) => CustomSelectionDialogItem(
                      onTap: () => Navigator.pop(context, timetable),
                      selected: selectedTimetable.id == timetable.id,
                      text: 'Timetable ${timetable.week}',
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
    if (timetable == null) return;
    return timetableVM.switchTimetable(timetable);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final TimetableVM timetableVM = context.watch<TimetableVM>();

    return StreamBuilder<Timetable>(
      stream: timetableVM.activeTimetableStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<Timetable> timetableSnapshot,
      ) {
        final Timetable timetable = timetableSnapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('Timetable'),
            leading: MenuButton(),
            actions: <Widget>[
              Center(
                child: Semantics(
                  onTapHint: 'switch timetables',
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(App.borderRadius),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => selectTimetable(timetable),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          timetable != null
                              ? 'Timetable ${timetable.week}'
                              : 'Select',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.ellipsisV),
                onPressed: openTimetableSettings,
                tooltip: 'Timetable Settings',
              )
            ],
          ),
          body: StreamBuilder<List<Lesson>>(
            stream: timetableVM.activeLessonListStream,
            initialData: const <Lesson>[],
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Lesson>> snapshot,
            ) {
              final List<Lesson> lessons = snapshot.data;

              final Map<int, Map<int, Lesson>> lessonMap =
                  <int, Map<int, Lesson>>{};

              final int lessonsPerDay = timetableVM.lessonsPerDay;

              for (int i = 1; i <= lessonsPerDay; i++) {
                lessonMap[i] = <int, Lesson>{};
              }

              for (Lesson lesson in lessons) {
                if (lesson.period > lessonsPerDay) continue;
                lessonMap[lesson.period][lesson.weekday] = lesson;
              }

              if (timetableSnapshot.hasData) {
                return SingleChildScrollView(
                  child: _Timetable(
                    lessonMap: lessonMap,
                    lessonsPerDay: lessonsPerDay,
                    timetable: timetable,
                  ),
                );
              }
              if (timetableSnapshot.connectionState ==
                      ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator();
              }
              return const ErrorMessage();
            },
          ),
        );
      },
    );
  }
}

class _EmptyLesson extends StatelessWidget {
  const _EmptyLesson({
    Key key,
    @required this.selected,
    @required this.onTap,
  }) : super(key: key);

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: selected
            ? Center(
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _TimetableLesson extends StatelessWidget {
  const _TimetableLesson({Key key, @required this.lesson}) : super(key: key);

  final Lesson lesson;

  void openLessonPage(BuildContext context) =>
      Navigator.pushNamed(context, ViewLessonPage.routeName, arguments: lesson);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: false,
      transitionType: ContainerTransitionType.fade,
      openBuilder: (_, __) => ViewLessonPage(lesson: lesson),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(App.borderRadius),
      ),
      closedElevation: 0,
      closedColor: lesson.subject.color.withOpacity(0.75),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: openContainer,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Text(
                    lesson.subject.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        .copyWith(color: Colors.white, letterSpacing: 0.5),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      lesson.room ?? lesson.subject.room ?? '--',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Icon(
                      lesson.subject.icon ?? FontAwesomeIcons.laptopCode,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Timetable extends StatefulWidget {
  const _Timetable({
    Key key,
    @required this.lessonMap,
    @required this.lessonsPerDay,
    @required this.timetable,
  }) : super(key: key);

  final Map<int, Map<int, Lesson>> lessonMap;
  final int lessonsPerDay;
  final Timetable timetable;

  static const Map<int, TableColumnWidth> _colunmWidths =
      <int, TableColumnWidth>{0: FixedColumnWidth(16)};

  @override
  __TimetableState createState() => __TimetableState();
}

class __TimetableState extends State<_Timetable> {
  List<Widget> dayHeaders;
  int days;

  int selectedDay;
  int selectedPeriod;

  @override
  void initState() {
    super.initState();
    days = 5 +
        (widget.timetable.saturdayEnabled ? 1 : 0) +
        (widget.timetable.sundayEnabled ? 1 : 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateDayHeaders();
  }

  @override
  void didUpdateWidget(_Timetable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.timetable.saturdayEnabled !=
            widget.timetable.saturdayEnabled ||
        oldWidget.timetable.sundayEnabled != widget.timetable.sundayEnabled) {
      updateDayHeaders();
      days = 5 +
          (widget.timetable.saturdayEnabled ? 1 : 0) +
          (widget.timetable.sundayEnabled ? 1 : 0);
    }
  }

  void updateDayHeaders() {
    final DateTime now = DateTime.now();
    dayHeaders = <Widget>[
      const SizedBox.shrink(),
      for (int i = 1; i <= 7; i++)
        Center(
          child: Text(
            '${dayToShortString(i)}',
            style: now.weekday == i
                ? TextStyle(color: Theme.of(context).colorScheme.primary)
                : null,
          ),
        ),
    ];

    if (!widget.timetable.saturdayEnabled) {
      dayHeaders.removeAt(dayHeaders.length - 2);
    }
    if (!widget.timetable.sundayEnabled) {
      dayHeaders.removeLast();
    }
  }

  void openAddLessonPage(TimetablePosition dayPeriod) => Navigator.pushNamed(
        context,
        AddLessonPage.routeName,
        arguments: dayPeriod,
      );

  void addLesson(int day, int period) {
    if (selectedDay == day && selectedPeriod == period) {
      setState(() {
        selectedDay = null;
        selectedPeriod = null;
      });
      openAddLessonPage(
        TimetablePosition(
          period: period,
          weekday: day,
          timetable: widget.timetable,
        ),
      );
    } else {
      setState(() {
        selectedDay = day;
        selectedPeriod = period;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TableRow> rows = <TableRow>[];

    for (int period = 1; period <= widget.lessonsPerDay; period++) {
      final List<Widget> lessons = <Widget>[];

      for (int day = 1; day <= days; day++) {
        final bool selected = selectedDay == day && selectedPeriod == period;
        final bool containsLesson =
            widget.lessonMap[period]?.containsKey(day) ?? false;
        lessons.add(
          Container(
            height: 96,
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            child: containsLesson
                ? _TimetableLesson(lesson: widget.lessonMap[period][day])
                : _EmptyLesson(
                    selected: selected,
                    onTap: () => addLesson(day, period),
                  ),
          ),
        );
      }

      rows.add(
        TableRow(
          children: <Widget>[
            Center(child: Text('$period')),
            ...lessons,
          ],
        ),
      );
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: _Timetable._colunmWidths,
      children: <TableRow>[
        TableRow(children: dayHeaders),
        ...rows,
      ],
    );
  }
}
