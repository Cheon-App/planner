// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/widgets/priority_indicator.dart';
import 'package:cheon/widgets/subject_card.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/pages/assessments/view_exam_page.dart';

class ExamCard extends StatelessWidget {
  /// Creates a card containing information for an exam
  const ExamCard({
    Key key,
    @required this.exam,
  }) : super(key: key);

  final Exam exam;

  void openExam(BuildContext context) =>
      Navigator.pushNamed(context, ViewExamPage.routeName, arguments: exam);

  @override
  Widget build(BuildContext context) {
    final String seat =
        exam.seat?.isNotEmpty ?? false ? 'Seat ${exam.seat}' : '';
    final String location = exam.location ?? '';
    final int minutes = exam.end.difference(exam.start).inMinutes;
    return SubjectCard(
      onTap: () => openExam(context),
      color: exam.subject.color,
      title: exam.title,
      subtitle: '${exam.subject.name} | Exam ',
      trailing: MaterialLocalizations.of(context).formatMediumDate(exam.start) +
          ' | ' +
          MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay.fromDateTime(exam.start),
          ),
      trailingSubtitle: Row(
        children: <Widget>[
          const Text('Priority:'),
          PriorityIndicator(color: exam.subject.color, priority: exam.priority),
        ],
      ),
      bottom: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$seat${seat.isNotEmpty && location.isNotEmpty ? ' | ' : ''}'
                  '$location'),
              Text(
                '$minutes min',
                style: Theme.of(context).textTheme.subtitle2,
              )
            ],
          ),
        ],
      ),
      dense: true,
    );
  }
}
