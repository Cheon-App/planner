// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/app.dart';
import 'package:cheon/widgets/cheon_page.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/study_session_card.dart';
import 'package:cheon/widgets/subject_card.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/calendar_event.dart';
import 'package:cheon/models/compare_time.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/lesson.dart';
import 'package:cheon/models/study_session.dart';
import 'package:cheon/models/timeline_data.dart';
import 'package:cheon/models/timetable.dart';
import 'package:cheon/pages/add_event/add_event_page.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/pages/assessments/view_exam_page.dart';
import 'package:cheon/pages/lessons/view_lesson_page.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/timeline_view_model.dart';

class TimelinePage extends StatefulWidget {
  /// Creates a page containing upcoming homework, and exams
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void jumpToToday() =>
      Provider.of<TimelineVM>(context, listen: false).selectedDate =
          strippedDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TimelineVM timelineVM = Provider.of<TimelineVM>(context);
    final Timetable timetable = timelineVM.selectedTimetable;
    return CheonPage(
      actions: <Widget>[
        IconButton(
          icon: const Icon(FontAwesomeIcons.calendarDay),
          onPressed: jumpToToday,
          tooltip: 'Jump To Today',
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: _DateSelector(
              onDateChanged: (DateTime dateTime) =>
                  timelineVM.selectedDate = dateTime,
              selectedDate: timelineVM.selectedDate,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  '${dayToString(timelineVM.selectedDate.weekday)}, '
                  '${timelineVM.selectedDate.day} '
                  '${monthToString(timelineVM.selectedDate.month)}',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(),
                Text(
                  timetable != null ? 'Week ${timetable.week}' : 'No lessons',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: TimelineList()),
        ],
      ),
    );
  }
}

class _DateSelector extends StatefulWidget {
  const _DateSelector({
    Key key,
    @required this.onDateChanged,
    @required this.selectedDate,
  })  : assert(onDateChanged != null),
        assert(selectedDate != null),
        super(key: key);

  final Function(DateTime) onDateChanged;
  final DateTime selectedDate;

  @override
  __DateSelectorState createState() => __DateSelectorState();
}

class __DateSelectorState extends State<_DateSelector> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    // 0-27 before the current week and 29-56 afterwards
    _pageController = PageController(initialPage: 28);
  }

  @override
  void didUpdateWidget(_DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Jumps to the current week if the selected date is changed to one that
    // isn't in view e.g. when jumping to the current day
    if (widget.selectedDate == strippedDateTime(DateTime.now()) &&
        ((oldWidget.selectedDate != widget.selectedDate) ||
            _pageController.page != 28)) {
      _pageController.animateToPage(
        28,
        duration: DURATION_LONG,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  // Creates a single letter representing the day of the week
  Widget dayLetter(BuildContext context, String letter) {
    return SizedBox(
      width: 40,
      child: Opacity(
        opacity: 0.75,
        child: Text(
          letter,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = strippedDateTime(DateTime.now());

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            dayLetter(context, 'M'),
            dayLetter(context, 'T'),
            dayLetter(context, 'W'),
            dayLetter(context, 'T'),
            dayLetter(context, 'F'),
            dayLetter(context, 'S'),
            dayLetter(context, 'S'),
          ],
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            // 28 weeks before and after the current week
            itemCount: 57,
            itemBuilder: (BuildContext context, int week) {
              final DateTime weekStart =
                  startOfWeek(now).add(Duration(days: (week - 28) * 7));
              return _DateRow(
                currentDate: now,
                onDateSelected: widget.onDateChanged,
                days: List<int>.generate(7, (int i) => i)
                    .map<DateTime>(
                      (int index) => weekStart.add(Duration(days: index)),
                    )
                    .toList(),
                selectedDay: widget.selectedDate,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow(
      {Key key,
      this.days,
      this.selectedDay,
      this.currentDate,
      this.onDateSelected})
      : super(key: key);
  final List<DateTime> days;
  final DateTime selectedDay;
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (DateTime date in days)
          Container(
            height: 40,
            width: 40,
            decoration: date == currentDate && date != selectedDay
                ? BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(App.borderRadius),
                  )
                : null,
            child: Material(
              color: date == selectedDay
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(App.borderRadius),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onDateSelected(date),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: date == selectedDay
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

@visibleForTesting
class TimelineList extends StatefulWidget {
  @override
  _TimelineListState createState() => _TimelineListState();
}

class _TimelineListState extends State<TimelineList> {
  Stream<TimelineData> _timelineDataStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TimelineVM timelineVM =
        Provider.of<TimelineVM>(context, listen: false);
    _timelineDataStream ??= timelineVM.timelineDataStream();
  }

  Widget addEvent(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          height: 24,
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          child: DottedBorder(
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(App.borderRadius),
            strokeCap: StrokeCap.round,
            dashPattern: const <double>[10, 10],
            padding: const EdgeInsets.all(0),
            child: InkWell(
              borderRadius: BorderRadius.circular(App.borderRadius),
              onTap: () {},
              child: Center(
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget compareTimeToCard(CompareTime compareTime) {
    switch (compareTime.runtimeType) {
      case Lesson:
        return _LessonCard(lesson: compareTime as Lesson);
        break;
      case Exam:
        return _ExamCard(exam: compareTime as Exam);
        break;
      case CalendarEvent:
        return _EventCard(event: compareTime as CalendarEvent);
        break;
      case StudySession:
        return StudySessionCard(studySession: compareTime as StudySession);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TimelineData>(
      stream: _timelineDataStream,
      builder: (BuildContext context, AsyncSnapshot<TimelineData> snapshot) {
        if (snapshot.hasData) {
          final TimelineData timelineData = snapshot.data;
          if (timelineData.isEmpty) {
            return Column(
              children: const <Widget>[
                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _DashboardCard(),
                ), */
                 Expanded(
                  child: EmptyPlaceholder(
                    svgPath: IMG_TIMELINE,
                    text: 'No events on this day.',
                  ),
                ),
              ],
            );
          } else {
            final List<CompareTime> allEventsList = <CompareTime>[
              ...timelineData.lessonList,
              ...timelineData.examList,
              ...timelineData.eventList,
              ...timelineData.studySessionList,
            ]..sort(
                (CompareTime a, CompareTime b) =>
                    a.compareTimeTo(b.compareTime),
              );
            final List<Widget> children = <Widget>[];

            while (allEventsList.isNotEmpty) {
              // Events occuring at the same time
              final List<CompareTime> gropuedEvents = <CompareTime>[];
              final CompareTime first = allEventsList.first;

              while (allEventsList.first.compareTime == first.compareTime) {
                gropuedEvents.add(allEventsList.removeAt(0));
                if (allEventsList.isEmpty) break;
              }

              children.add(
                _TimeRow(
                  time: gropuedEvents.first.compareTime,
                  children: gropuedEvents
                      .map((CompareTime compareTime) =>
                          compareTimeToCard(compareTime))
                      .toList(),
                ),
              );
            }
            // children.add(_AddEventButton());

            return Column(
              children: <Widget>[
                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _DashboardCard(),
                ), */
                Expanded(
                  child: ListView(
                    primary: false,
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 84,
                    ),
                    children: children,
                  ),
                ),
              ],
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }
        return const ErrorMessage();
      },
    );
  }
}

class _AddEventButton extends StatelessWidget {
  void openAddEventPage(BuildContext context) {
    // TODO replace this with adding a study session.
    Navigator.pushNamed(
      context,
      AddEventPage.routeName,
      arguments: EventType.TASK,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Tooltip(
          message: 'Add Event',
          child: Container(
            height: 24,
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            child: DottedBorder(
              color: Theme.of(context).colorScheme.secondary,
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: const Radius.circular(App.borderRadius),
              strokeCap: StrokeCap.round,
              dashPattern: const <double>[10, 10],
              padding: const EdgeInsets.all(0),
              child: InkWell(
                borderRadius: BorderRadius.circular(App.borderRadius),
                onTap: () => openAddEventPage(context),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({Key key, @required this.lesson})
      : assert(lesson != null),
        super(key: key);

  final Lesson lesson;

  void openLesson(BuildContext context) =>
      Navigator.pushNamed(context, ViewLessonPage.routeName, arguments: lesson);

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      color: lesson.subject.color,
      title: '${lesson.subject.name} Lesson',
      trailing: lesson.room,
      subtitle: lesson.teacher?.name,
      onTap: () => openLesson(context),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({Key key, @required this.exam})
      : assert(exam != null),
        super(key: key);

  final Exam exam;

  void openExam(BuildContext context) =>
      Navigator.pushNamed(context, ViewExamPage.routeName, arguments: exam);

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      color: exam.subject.color,
      title: exam.title,
      trailing: '${exam.end.difference(exam.start).inMinutes} min',
      subtitle: '${exam.subject.name} | Exam',
      trailingSubtitle: Text(exam.location ?? ''),
      onTap: () => openExam(context),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({Key key, this.event}) : super(key: key);
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                event.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              event.description.trim().isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(FontAwesomeIcons.alignLeft, size: 12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              event.location.trim().isNotEmpty
                  ? Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.mapMarkerAlt, size: 12),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Returns a group of cards for events occuring at [time] along with text
/// indicating that time
class _TimeRow extends StatelessWidget {
  const _TimeRow({
    Key key,
    @required this.time,
    @required this.children,
  })  : assert(time != null),
        assert(children != null),
        super(key: key);

  final TimeOfDay time;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 4),
                Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(time),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          )
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  Widget infoTile(BuildContext context, {String number, String text}) {
    return Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$number',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' $text',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineVM = context.watch<TimelineVM>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              infoTile(
                context,
                number: '${timelineVM.sessionsToGo}',
                text: 'sessions to go',
              ),
              const VerticalDivider(),
              infoTile(
                context,
                number: '${timelineVM.tasksToGo}',
                text: 'tasks to go',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
