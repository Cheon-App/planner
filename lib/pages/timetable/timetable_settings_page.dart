import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/platform_date_time_picker.dart';
import 'package:cheon/widgets/primary_action_button.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/lesson_time.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/view_models/timetable_view_model.dart';
import 'package:cheon/widgets/tap_to_dismiss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TimetableSettingsPage extends StatelessWidget {
  const TimetableSettingsPage({Key key}) : super(key: key);

  static const String routeName = '/timetable_settings';

  @override
  Widget build(BuildContext context) {
    return TapToDismiss(
      child: Scaffold(
        appBar: AppBar(title: const Text('Timetable settings')),
        body: _SettingsTabs(),
      ),
    );
  }
}

class _SettingsTabs extends StatefulWidget {
  @override
  __SettingsTabsState createState() => __SettingsTabsState();
}

class __SettingsTabsState extends State<_SettingsTabs>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void changePage(int index) {
    if (tabIndex == index) return;
    setState(() {
      tabIndex = index;
      _pageController.animateToPage(
        index,
        duration: DURATION_MEDIUM,
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CupertinoSlidingSegmentedControl<int>(
            onValueChanged: changePage,
            groupValue: tabIndex,
            children: const <int, Widget>{
              0: Text('TIMETABLES'),
              1: Text('OPTIONS'),
              2: Text('LESSON TIMES'),
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              _TimetableList(),
              OptionsList(),
              _PeriodList(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodList extends StatefulWidget {
  @override
  __PeriodListState createState() => __PeriodListState();
}

class __PeriodListState extends State<_PeriodList> {
  int lessons;
  TextEditingController _lessonsPerDayController;

  @override
  void initState() {
    super.initState();
    _lessonsPerDayController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _lessonsPerDayController.dispose();
  }

  Future<void> updateLessonsPerDay({
    int lessons,
    List<LessonTime> lessonTimeList,
  }) async {
    if (this.lessons == lessons) return;
    if (lessons > 20 || lessons < 1) return;
    this.lessons = lessons;
    final TimetableVM timetableVM = context.read<TimetableVM>();

    if (lessons > lessonTimeList.length) {
      // Add lesson times
      for (int i = lessonTimeList.length + 1; i <= lessons; i++) {
        await timetableVM.addLessonTime(i, DateTime(0, 0, 0, i + 8, 0));
      }
    } else if (lessons < lessonTimeList.length) {
      // Remove lesson times

      for (int i = lessonTimeList.length; i > lessons; i--) {
        await timetableVM.deleteLessonTime(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimetableVM timetableVM = context.watch<TimetableVM>();
    return StreamBuilder<List<LessonTime>>(
      stream: timetableVM.lessonTimeListStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<LessonTime>> snapshot,
      ) {
        final List<LessonTime> lessonTimes = snapshot.data ?? <LessonTime>[];
        if (_lessonsPerDayController.text.isEmpty && snapshot.hasData) {
          _lessonsPerDayController.text = lessonTimes.length.toString();
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: <Widget>[
            Form(
              autovalidate: true,
              child: TextFormField(
                controller: _lessonsPerDayController,
                decoration: const InputDecoration(labelText: 'Lessons Per Day'),
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.isEmpty) return null;
                  return int.parse(value) > 20
                      ? 'Must be 20 or lower.'
                      : int.parse(value) < 1 ? 'Must be 1 or higher.' : null;
                },
                onChanged: (String value) => updateLessonsPerDay(
                  lessons: int.parse(value),
                  lessonTimeList: lessonTimes,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ListView.builder(
              itemCount: lessonTimes.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => _PeriodCard(
                lessonTime: lessonTimes[index],
              ),
            )
          ],
        );
      },
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({Key key, @required this.lessonTime})
      : assert(lessonTime != null),
        super(key: key);

  final LessonTime lessonTime;

  Future<void> changePeriodStart(BuildContext context, TimeOfDay time) async {
    if (time == null) return;
    final TimetableVM timetableVM = context.read<TimetableVM>();
    await timetableVM.updateLessonTime(
        lessonTime, DateTime(0, 0, 0, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    final String timeString =
        MaterialLocalizations.of(context).formatTimeOfDay(lessonTime.time);
    return Card(
      child: ListTile(
        title: Text('Lesson ${lessonTime.period}'),
        trailing: Text(timeString),
        onTap: () => showPlatformTimePicker(
          context: context,
          initialTime: lessonTime.time,
        ).listen((TimeOfDay time) => changePeriodStart(context, time)),
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  void setLessonLength(
    BuildContext context, {
    @required Duration oldLessonLength,
  }) {}

  @override
  Widget build(BuildContext context) {
    final TimetableVM timetableVM = context.watch<TimetableVM>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              tiles: <Widget>[
                SwitchListTile.adaptive(
                  title: const Text('Auto switch timetables'),
                  onChanged: (bool b) => timetableVM.autoSwitch = b,
                  value: timetableVM.autoSwitch,
                ),
                /* SwitchListTile.adaptive(
                  title: const Text('Switch timetables in holidays'),
                  onChanged: timetableVM.autoSwitch
                      ? (bool b) => timetableVM.switchInHolidays = b
                      : null,
                  value: timetableVM.switchInHolidays,
                ), */
                /* SwitchListTile.adaptive(
                  title: const Text('Use letters'),
                  onChanged: null, // (bool b) => timetableVM.useLetters = b,
                  value: timetableVM.useLetters,
                ),
                ListTile(
                  title: const Text('Lesson length'),
                  trailing: Text('${timetableVM.lessonLength.inMinutes} min'),
                  onTap: () => setLessonLength(
                    context,
                    oldLessonLength: timetableVM.lessonLength,
                  ),
                  enabled: false,
                ), */
              ],
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class _TimetableList extends StatelessWidget {
  Future<void> addTimetable(BuildContext context,
      {@required List<Timetable> timetables}) {
    final TimetableVM timetableVM = context.read<TimetableVM>();

    return timetableVM.addTimetable(index: timetables.length + 1);
  }

  @override
  Widget build(BuildContext context) {
    final TimetableVM timetableVM = Provider.of<TimetableVM>(
      context,
      listen: false,
    );
    return StreamBuilder<List<Timetable>>(
      stream: timetableVM.timetableListStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Timetable>> snapshot,
      ) {
        if (snapshot.hasData) {
          final List<Timetable> timetables = snapshot.data;
          return Column(
            children: <Widget>[
              Expanded(
                child: timetables.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: timetables.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _TimetableCard(
                          key: ValueKey<String>(timetables[index].id),
                          timetable: timetables[index],
                        ),
                      )
                    : const EmptyPlaceholder(text: 'No timetables.'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryActionButton(
                  onTap: () => addTimetable(context, timetables: timetables),
                  text: 'ADD TIMETABLE',
                ),
              ),
            ],
          );
        }
        return const ErrorMessage();
      },
    );
  }
}

class _TimetableCard extends StatefulWidget {
  const _TimetableCard({
    Key key,
    @required this.timetable,
  })  : assert(timetable != null),
        super(key: key);

  final Timetable timetable;

  @override
  __TimetableCardState createState() => __TimetableCardState();
}

class __TimetableCardState extends State<_TimetableCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  bool isFirstTimetable;

  @override
  void initState() {
    super.initState();
    isFirstTimetable = widget.timetable.week == 1;
  }

  void toggleExpanded() => setState(() => expanded = !expanded);

  void showSaturday(bool showSaturday) {
    final TimetableVM timetableVM = context.read<TimetableVM>();

    timetableVM.updateTimetable(widget.timetable, showSaturday: showSaturday);
  }

  void showSunday(bool showSunday) {
    final TimetableVM timetableVM = context.read<TimetableVM>();

    timetableVM.updateTimetable(widget.timetable, showSunday: showSunday);
  }

  Future<void> deleteTimetable() {
    final TimetableVM timetableVM = context.read<TimetableVM>();
    return timetableVM.deleteTimetable(widget.timetable);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Timetable ${widget.timetable.week}'),
            contentPadding: const EdgeInsets.only(left: 16),
            trailing: IconButton(
              icon: Icon(
                expanded
                    ? FontAwesomeIcons.chevronUp
                    : FontAwesomeIcons.chevronDown,
              ),
              onPressed: toggleExpanded,
            ),
          ),
          AnimatedSize(
            vsync: this,
            duration: DURATION_SHORT,
            child: expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Divider(height: 0),
                      SwitchListTile.adaptive(
                        value: widget.timetable.saturdayEnabled,
                        onChanged: showSaturday,
                        title: const Text('Show Saturday'),
                      ),
                      SwitchListTile.adaptive(
                        value: widget.timetable.sundayEnabled,
                        onChanged: showSunday,
                        title: const Text('Show Sunday'),
                      ),
                      !isFirstTimetable
                          ? FlatButton(
                              child: const Text('DELETE'),
                              textColor: Theme.of(context).colorScheme.error,
                              onPressed: deleteTimetable,
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
