// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/core/dates/date_filter.dart';
import 'package:cheon/models/assessment.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/models/test.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:cheon/widgets/empty_placeholder.dart';
import 'package:cheon/widgets/error_message.dart';
import 'package:cheon/widgets/exam_card.dart';
import 'package:cheon/widgets/loading_indicator.dart';
import 'package:cheon/widgets/menu_button.dart';
import 'package:cheon/widgets/sticky_section.dart';
import 'package:cheon/widgets/test_card.dart';

class AssessmentsPage extends StatefulWidget {
  /// Creates a page containing upcoming exams and tests
  const AssessmentsPage({Key key, this.inHomePage = true}) : super(key: key);

  static const String routeName = '/assessments';
  final bool inHomePage;

  @override
  AssessmentsPagePageState createState() => AssessmentsPagePageState();
}

@visibleForTesting
class AssessmentsPagePageState extends State<AssessmentsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // True if assessments occuring now and in the future should be shown
  bool _showCurrent = true;
  final dateFilter = DateFilter();

  void toggleShowCurrent() => setState(() => _showCurrent = !_showCurrent);

  List<Assessment> assessmentListToday(List<Assessment> assessmentList) {
    return assessmentList
        .where((a) => dateFilter.isToday(a.compareDateTime))
        .toList();
  }

  List<Assessment> assessmentListTomorrow(List<Assessment> assessmentList) {
    return assessmentList
        .where((a) => dateFilter.isTomorrow(a.compareDateTime))
        .toList();
  }

  List<Assessment> assessmentListThisWeek(List<Assessment> assessmentList) {
    return assessmentList
        .where((a) => dateFilter.isThisWeek(a.compareDateTime))
        .toList();
  }

  List<Assessment> assessmentListNextWeek(List<Assessment> assessmentList) {
    return assessmentList
        .where((a) => dateFilter.isNextWeek(a.compareDateTime))
        .toList();
  }

  List<Assessment> assessmentListOther(List<Assessment> assessmentList) {
    return assessmentList
        .where((a) => dateFilter.isOther(a.compareDateTime))
        .toList();
  }

  Widget assessmentToCard(Assessment assessment) {
    if (assessment is Exam) {
      return ExamCard(exam: assessment);
    } else if (assessment is Test) {
      return TestCard(test: assessment);
    } else {
      return const SizedBox.shrink();
    }
  }

  List<Widget> sectionCardsFromList(List<Assessment> assessmentList) {
    final List<Assessment> sortedAssessmentList = assessmentList
      ..sort(
        (Assessment a, Assessment b) => a.compareDateTimeTo(b.compareDateTime),
      );
    return sortedAssessmentList
        .map((Assessment assessment) => assessmentToCard(assessment))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ExamsVM vm = Provider.of<ExamsVM>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Assessments'),
        leading: MenuButton(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(FontAwesomeIcons.history),
            onPressed: toggleShowCurrent,
            tooltip: _showCurrent ? 'Past Tests/Exams' : 'Current Tests/Exams`',
          )
        ],
      ),
      body: StreamBuilder<List<Assessment>>(
        stream: _showCurrent
            ? vm.currentAssessmentListStream
            : vm.pastAssessmentListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Assessment>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return EmptyPlaceholder(
                svgPath: IMG_EXAMS,
                text: _showCurrent
                    ? 'No future tests or exams.'
                    : 'No past tests or exams.',
              );
            }
            if (_showCurrent) {
              final List<Assessment> today = assessmentListToday(snapshot.data);
              final List<Assessment> tomorrow =
                  assessmentListTomorrow(snapshot.data);
              final List<Assessment> thisWeek =
                  assessmentListThisWeek(snapshot.data);
              final List<Assessment> nextWeek =
                  assessmentListNextWeek(snapshot.data);
              final List<Assessment> other = assessmentListOther(snapshot.data);

              return ListView(
                primary: false,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 84),
                children: <Widget>[
                  today.isNotEmpty
                      ? StickySection(
                          name: 'Today',
                          children: sectionCardsFromList(today),
                        )
                      : const SizedBox.shrink(),
                  tomorrow.isNotEmpty
                      ? StickySection(
                          name: 'Tomorrow',
                          children: sectionCardsFromList(tomorrow),
                        )
                      : const SizedBox.shrink(),
                  thisWeek.isNotEmpty
                      ? StickySection(
                          name: 'This Week',
                          children: sectionCardsFromList(thisWeek),
                        )
                      : const SizedBox.shrink(),
                  nextWeek.isNotEmpty
                      ? StickySection(
                          name: 'Next Week',
                          children: sectionCardsFromList(nextWeek),
                        )
                      : const SizedBox.shrink(),
                  other.isNotEmpty
                      ? StickySection(
                          name: 'Other',
                          children: sectionCardsFromList(other),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            } else {
              return ListView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 84),
                children: <Widget>[
                  StickySection(
                    name: 'Past Tests/Exams',
                    children: sectionCardsFromList(snapshot.data),
                  )
                ],
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
