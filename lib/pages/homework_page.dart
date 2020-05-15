import 'package:cheon/components/dynamic_cheon_page.dart';
import 'package:cheon/components/empty_placeholder.dart';
import 'package:cheon/components/error_message.dart';
import 'package:cheon/components/linear_progress_bar.dart';
import 'package:cheon/components/loading_indicator.dart';
import 'package:cheon/components/sticky_section.dart';
import 'package:cheon/components/subject_card.dart';
import 'package:cheon/constants.dart';
import 'package:cheon/models/homework.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/homework_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cheon/pages/view_homework_page.dart';

class HomeworkPage extends StatefulWidget {
  /// Creates a page containing a list of homework and other tasks
  const HomeworkPage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/homework';
  final bool inHomePage;

  @override
  HomeworkPageState createState() => HomeworkPageState();
}

@visibleForTesting
class HomeworkPageState extends State<HomeworkPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  bool _showCurrent = true;
  @visibleForTesting
  DateTime now = strippedDateTime(DateTime.now());

  void _toggleHomeworkMode() => setState(() => _showCurrent = !_showCurrent);

  /// Returns a [DateTime] matching the start of the week i.e. 00:00 on Monday.
  DateTime startOfWeek(DateTime dateTime) =>
      strippedDateTime(dateTime).subtract(Duration(days: dateTime.weekday - 1));

  /// Returns a list of incomplete homework that are also due in the past.
  List<Homework> overdueHomework(List<Homework> all) =>
      all.where((Homework a) => !a.complete() && a.due.isBefore(now)).toList();

  /// Returns a list of homework due today.
  List<Homework> homeworkToday(List<Homework> all) =>
      all.where((Homework a) => strippedDateTime(a.due) == now).toList();

  /// Returns a list of homework due tomorrow.
  List<Homework> homeworkTomorrow(List<Homework> all) => all
      .where((Homework a) => strippedDateTime(a.due)
          .isAtSameMomentAs(now.add(const Duration(days: 1))))
      .toList();

  /// Returns a list of homework due this week excluding homework due
  /// today or tomorrow
  List<Homework> homeworkThisWeek(List<Homework> all) {
    final DateTime weekStart = startOfWeek(now);
    final DateTime weekEnd = weekStart.add(const Duration(days: 7));

    return all.where(
      (Homework a) {
        return (a.due.isAfter(now.add(const Duration(days: 2))) ||
                a.due.isAtSameMomentAs(now.add(const Duration(days: 2)))) &&
            strippedDateTime(a.due).isBefore(weekEnd);
      },
    ).toList();
  }

  /// Returns a list of homework due next week excluding homework due today and
  ///  tomorrow
  List<Homework> homeworkNextWeek(List<Homework> all) {
    // final bool isSaturday = now.weekday == DateTime.saturday;
    final bool isSunday = now.weekday == DateTime.sunday;
    final DateTime nextWeekStart = startOfWeek(now).add(
      const Duration(days: 7),
    );

    final DateTime nextWeekEnd = nextWeekStart.add(const Duration(days: 7));
    return all
        .where(
          (Homework a) =>
              (a.due.isAfter(
                    nextWeekStart.add(Duration(days: isSunday ? 1 : 0)),
                  ) ||
                  a.due.isAtSameMomentAs(
                    nextWeekStart.add(Duration(days: isSunday ? 1 : 0)),
                  )) &&
              a.due.isBefore(nextWeekEnd),
        )
        .toList();
  }

  /// Returns a list of homework that are not due this week or next week.
  List<Homework> otherHomework(List<Homework> all) {
    final DateTime nextWeekEnd = now
        .add(Duration(days: DateTime.sunday - now.weekday + 1))
        .add(const Duration(days: 7));
    return all
        .where((Homework a) =>
            a.due.isAfter(nextWeekEnd) || a.due.isAtSameMomentAs(nextWeekEnd))
        .toList();
  }

  List<Widget> homeworkCardFromList(List<Homework> homeworkList) {
    homeworkList.sort((Homework a, Homework b) => a.due.compareTo(b.due));
    return homeworkList
        .map((Homework homework) => _HomeworkCard(homework: homework))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Stream<List<Homework>> currentHomeworkStream =
        context.select<HomeworkVM, Stream<List<Homework>>>(
            (HomeworkVM vm) => vm.currentHomeworkStream);
    final Stream<List<Homework>> pastHomeworkStream =
        context.select<HomeworkVM, Stream<List<Homework>>>(
            (HomeworkVM vm) => vm.pastHomeworkStream);

    return DynamicCheonPage(
      title: 'Homework',
      inHomePage: widget.inHomePage,
      actions: <Widget>[
        IconButton(
          icon: const Icon(FontAwesomeIcons.history),
          onPressed: _toggleHomeworkMode,
          tooltip: _showCurrent ? 'Past Homework' : 'Current Homework',
        ),
      ],
      child: StreamBuilder<List<Homework>>(
        stream: _showCurrent ? currentHomeworkStream : pastHomeworkStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Homework>> snapshot,
        ) {
          const EdgeInsetsGeometry scrollablePadding =
              EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 84);
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              if (_showCurrent) {
                final List<Homework> overdueHomework =
                    this.overdueHomework(snapshot.data);
                final List<Homework> homeworkToday =
                    this.homeworkToday(snapshot.data);
                final List<Homework> homeworkTomorrow =
                    this.homeworkTomorrow(snapshot.data);
                final List<Homework> homeworkThisWeek =
                    this.homeworkThisWeek(snapshot.data);
                final List<Homework> homeworkNextWeek =
                    this.homeworkNextWeek(snapshot.data);
                final List<Homework> otherHomework =
                    this.otherHomework(snapshot.data);
                return ListView(
                  primary: false,
                  padding: scrollablePadding,
                  children: <Widget>[
                    overdueHomework.isNotEmpty
                        ? StickySection(
                            name: 'Overdue',
                            warning: true,
                            children: homeworkCardFromList(overdueHomework),
                          )
                        : const SizedBox.shrink(),
                    homeworkToday.isNotEmpty
                        ? StickySection(
                            name: 'Today',
                            children: homeworkCardFromList(homeworkToday),
                          )
                        : const SizedBox.shrink(),
                    homeworkTomorrow.isNotEmpty
                        ? StickySection(
                            name: 'Tomorrow',
                            children: homeworkCardFromList(homeworkTomorrow),
                          )
                        : const SizedBox.shrink(),
                    homeworkThisWeek.isNotEmpty
                        ? StickySection(
                            name: 'This Week',
                            children: homeworkCardFromList(homeworkThisWeek),
                          )
                        : const SizedBox.shrink(),
                    homeworkNextWeek.isNotEmpty
                        ? StickySection(
                            name: 'Next Week',
                            children: homeworkCardFromList(homeworkNextWeek),
                          )
                        : const SizedBox.shrink(),
                    otherHomework.isNotEmpty
                        ? StickySection(
                            name: 'Other Homework',
                            children: homeworkCardFromList(otherHomework),
                          )
                        : const SizedBox.shrink()
                  ],
                );
              } else {
                return ListView(
                  primary: false,
                  padding: scrollablePadding,
                  children: <Widget>[
                    StickySection(
                      name: 'Past Homework',
                      children: homeworkCardFromList(snapshot.data),
                    )
                  ],
                );
              }
            } else {
              return EmptyPlaceholder(
                svgPath: IMG_TASKS,
                text: _showCurrent ? 'No homework due.' : 'No past homework',
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          return const ErrorMessage();
        },
      ),
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  const _HomeworkCard({Key key, @required this.homework}) : super(key: key);

  final Homework homework;

  void openHomework(BuildContext context) {
    Navigator.pushNamed(
      context,
      ViewHomeworkPage.routeName,
      arguments: homework,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCard(
      color: homework.subject.color,
      title: homework.title,
      trailing: '${dateTimeToDayMonth(homework.due)}',
      subtitle: '${homework.subject.name}',
      onTap: () => openHomework(context),
      bottom: homework.length != Duration.zero
          ? LinearProgressBar(
              key: ValueKey<String>(homework.id),
              color: homework.subject.color,
              fraction: homework.progress,
            )
          : null,
    );
  }
}
