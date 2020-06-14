// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:cheon/models/subject.dart';
import 'package:cheon/widgets/raised_action_page.dart';
import 'package:cheon/widgets/raised_body.dart';
import 'package:cheon/models/exam.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:cheon/widgets/select_date_card.dart';
import 'package:cheon/widgets/select_subject_card.dart';
import 'package:cheon/widgets/select_time_card.dart';

/// Creates a page containing the details of the given exam
class ViewExamPage extends StatefulWidget {
  const ViewExamPage({Key key, @required this.exam}) : super(key: key);
  static const String routeName = '/exam';
  final Exam exam;

  @override
  _ViewExamPageState createState() => _ViewExamPageState();
}

class _ViewExamPageState extends State<ViewExamPage> {
  Subject _subject;

  @override
  void initState() {
    super.initState();
    _subject = widget.exam.subject;
  }

  Future<void> _deleteExam() {
    final ExamsVM examsVM = context.read<ExamsVM>();
    Navigator.pop(context);
    return examsVM.deleteExam(widget.exam);
  }

  Future<void> _setSubject(Subject subject) async {
    final examsVM = context.read<ExamsVM>();
    setState(() => _subject = subject);
    await examsVM.updateExam(widget.exam.id, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedActionPage(
      appBarTitle: '${_subject.name} Exam',
      color: _subject.color,
      primaryActionEnabled: false,
      showEditButton: false,
      extraAction: IconButton(
        onPressed: _deleteExam,
        icon: FaIcon(FontAwesomeIcons.trashAlt),
        tooltip: 'Delete',
      ),
      child: _ExamBody(
        exam: widget.exam,
        onSubjectChanged: _setSubject,
        subject: _subject,
      ),
      onDelete: _deleteExam,
    );
  }
}

class _ExamBody extends StatefulWidget {
  const _ExamBody({
    Key key,
    @required this.exam,
    @required this.subject,
    @required this.onSubjectChanged,
  }) : super(key: key);

  final Exam exam;
  final Subject subject;
  final ValueChanged<Subject> onSubjectChanged;

  @override
  __ExamBodyState createState() => __ExamBodyState();
}

class __ExamBodyState extends State<_ExamBody> {
  TextEditingController _titleController;
  TextEditingController _seatController;
  TextEditingController _locationController;
  TextEditingController _priorityController;
  DateTime _startDateTime;
  DateTime _endDateTime;
  String examID;

  @override
  void initState() {
    super.initState();
    final exam = widget.exam;
    examID = exam.id;
    _titleController = TextEditingController(text: exam.title);
    _seatController = TextEditingController(text: exam.seat);
    _locationController = TextEditingController(text: exam.location);
    _priorityController = TextEditingController(
      text: exam.priority.toString(),
    );
    _startDateTime = exam.start;
    _endDateTime = exam.end;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _seatController.dispose();
    _locationController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _setTitle(String title) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateExam(examID, name: title);
  }

  Future<void> _setDate(DateTime date) async {
    final examsVM = context.read<ExamsVM>();
    final start = date.withTime(_startDateTime.time);
    final end = date.withTime(_endDateTime.time);
    setState(() => _startDateTime = start);
    await examsVM.updateExam(examID, start: start, end: end);
  }

  Future<void> _setStartTime(TimeOfDay time) async {
    final examsVM = context.read<ExamsVM>();
    final start = _startDateTime.withTime(time);
    setState(() => _startDateTime = start);
    await examsVM.updateExam(examID, start: start);
  }

  Future<void> _setEndTime(TimeOfDay time) async {
    final examsVM = context.read<ExamsVM>();
    final end = _endDateTime.withTime(time);
    setState(() => _endDateTime = end);
    await examsVM.updateExam(examID, end: end);
  }

  Future<void> _setSeat(String seat) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateExam(examID, seat: seat);
  }

  Future<void> _setLocation(String location) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateExam(examID, location: location);
  }

  Future<void> _setPriority(String priority) async {
    final examsVM = context.read<ExamsVM>();
    await examsVM.updateExam(examID, priority: int.parse(priority));
  }

  @override
  Widget build(BuildContext context) {
    return RaisedBody(
      child: ListView(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        children: <Widget>[
          // Title
          TextField(
            onChanged: _setTitle,
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 4),
          // Date & Subject
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SelectDateCard(
                    date: _startDateTime,
                    onDateSelected: _setDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectSubjectCard(
                    onSubjectSelected: widget.onSubjectChanged,
                    subject: widget.subject,
                    isRequired: true,
                  ),
                ),
              ],
            ),
          ),
          // Start & End Time
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SelectTimeCard(
                    title: 'Start',
                    onTimeSelected: _setStartTime,
                    time: TimeOfDay.fromDateTime(_startDateTime),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectTimeCard(
                    title: 'End',
                    onTimeSelected: _setEndTime,
                    time: TimeOfDay.fromDateTime(_endDateTime),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Seat & Location
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _seatController,
                    onChanged: _setSeat,
                    decoration: InputDecoration(labelText: 'Seat'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    onChanged: _setLocation,
                    decoration: InputDecoration(labelText: 'Location'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priorityController,
            onChanged: _setPriority,
            decoration: InputDecoration(labelText: 'Revision Priority'),
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
