import 'package:animations/animations.dart';
import 'package:cheon/app.dart';
import 'package:cheon/components/platform_date_time_picker.dart';
import 'package:cheon/components/platform_selection_dialog.dart';
import 'package:cheon/components/primary_action_button.dart';
import 'package:cheon/components/raised_body.dart';
import 'package:cheon/components/select_subject_dialog.dart';
import 'package:cheon/components/tap_to_dismiss.dart';
import 'package:cheon/models/subject.dart';
import 'package:cheon/utils.dart';
import 'package:cheon/view_models/exams_view_model.dart';
import 'package:cheon/view_models/homework_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum EventType {
  HOMEWORK,
  TEST,
  EXAM,
}

class AddEventPage extends StatefulWidget {
  /// Creates a page that allows the user to add an event to their account
  const AddEventPage({Key key, this.eventType}) : super(key: key);

  static const String routeName = '/add_event';
  final EventType eventType;

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  /// True if enough valid information has been provided to allow the user to
  /// add the event.
  final bool _readyToAdd = true;

  /// The type of event e.g. homework, test, exam etc.
  EventType _eventType;

  /// Provides access to functions in the [_EventBody] widget.
  final GlobalKey<_EventBodyState> _eventBodyKey = GlobalKey<_EventBodyState>();

  @override
  void initState() {
    super.initState();
    // Initialises the event type to the one provided in the page constructor or
    // homework if no event type was provided.
    _eventType = widget.eventType ?? EventType.HOMEWORK;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Shows the EventType dialog as soon as the page is opened and context is
      // available
      selectEventType();
    });
  }

  /// Displays a dialog containing a list of event types to choose from. Once an
  /// event type is chosen, the page updates to reflect the users choice.
  Future<void> selectEventType() async {
    final EventType eventType = await showPlatformSelectionDialog(
      context: context,
      selectedItem: _eventType,
      items: EventType.values
          .map(
            (EventType type) => SelectionDialogItem<EventType>(
              name: eventTypeToString(type),
              value: type,
            ),
          )
          .toList(),
    );

    if (eventType != null) {
      setState(() {
        _eventType = eventType;
      });
    }
  }

  /// Creates the event with details provided by the user. This function invokes
  /// the add function in [_EventBody] which creates the event type selected by
  /// the user.
  void addEvent() => _eventBodyKey.currentState.add();

  /// Updates this page with the [EventType] provided.
  void updateEventType(EventType eventType) {
    if (_eventType != eventType) setState(() => _eventType = eventType);
  }

  @override
  Widget build(BuildContext context) {
    /// The name of the event being added.
    final String eventString = eventTypeToString(_eventType).toLowerCase();

    return TapToDismiss(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // extendBody: true,
        // An appbar showing the name of the event being added.
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.dark,
          title: Text(
            'Add $eventString',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        // _EventBody shows the relevant form based on the selected EventType
        body: _EventBody(
          key: _eventBodyKey,
          eventType: _eventType,
          onEventTypeSelected: updateEventType,
        ),
        // The add button
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(16),
          child: PrimaryActionButton(
            onTap: _readyToAdd ? addEvent : null,
            text: 'ADD',
          ),
        ),
      ),
    );
  }
}

/// Converts the [EventType] enum to a user friendly string.
String eventTypeToString(EventType eventType) {
  String type;
  switch (eventType) {
    case EventType.HOMEWORK:
      return 'Homework';
      break;
    case EventType.TEST:
      return 'Test';
      break;
    case EventType.EXAM:
      return 'Exam';
      break;
  }
  return type;
}

class _EventBody extends StatefulWidget {
  const _EventBody({
    Key key,
    @required this.eventType,
    @required this.onEventTypeSelected,
  })  : assert(eventType != null),
        assert(onEventTypeSelected != null),
        super(key: key);

  /// The event type selected by the user.
  final EventType eventType;

  /// A callback function invoked when the user selects a different event.
  final Function(EventType) onEventTypeSelected;

  @override
  _EventBodyState createState() => _EventBodyState();
}

class _EventBodyState extends State<_EventBody> {
  /// The following Global Keys provide access functions from their respective
  /// forms to enable events to be created.

  final GlobalKey<_HomeworkFormState> homeworkFormKey =
      GlobalKey<_HomeworkFormState>();
  final GlobalKey<_ExamFormState> examFormKey = GlobalKey<_ExamFormState>();
  final GlobalKey<_TestFormState> testFormKey = GlobalKey<_TestFormState>();
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();

  /// A controller for the name text field.
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Initialises the name controller;
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    // Disposes of the name controller to prevent a memory leak.
    _nameController.dispose();
  }

  /// Displays a Material Design Snackbar animating from the bottom of the
  /// screen to alert the suer that an error occured while validating their
  /// inputs
  void handleValidationError(String error) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  /// Determines which event type is selected then invokes the respective add
  /// function for that event type form.
  Future<void> add() async {
    if (_nameFormKey.currentState.validate() == false) return;
    try {
      switch (widget.eventType) {
        /* case EventType.EVENT:
          eventFormKey.currentState.addEvent();
          break; */
        case EventType.EXAM:
          await examFormKey.currentState.addExam();
          break;
        case EventType.HOMEWORK:
          await homeworkFormKey.currentState.addHomework();
          break;
        case EventType.TEST:
          await testFormKey.currentState.addTest();
          break;
      }
    } catch (error) {
      // If there was an issue validating inputs then this displays a warning.
      handleValidationError(error);
    }
  }

  // Determines which event type is selected then returns the respective event
  // form widget.
  Widget formWidget() {
    switch (widget.eventType) {
      case EventType.HOMEWORK:
        return _HomeworkForm(
          key: homeworkFormKey,
          name: _nameController.text,
          onEventTypeSelected: widget.onEventTypeSelected,
        );
      /*  case EventType.EVENT:
        return _EventForm(
          key: eventFormKey,
          name: _nameController.text,
          onEventTypeSelected: widget.onEventTypeSelected,
        ); */
      case EventType.EXAM:
        return _ExamForm(
          key: examFormKey,
          name: _nameController.text,
          onEventTypeSelected: widget.onEventTypeSelected,
        );
      case EventType.TEST:
        return _TestForm(
          key: testFormKey,
          name: _nameController.text,
          onEventTypeSelected: widget.onEventTypeSelected,
        );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    /// Styling for the name text field.
    final InputBorder nameBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      borderRadius: BorderRadius.circular(App.borderRadius),
    );

    /// Styling for the name text field.
    final TextStyle textFieldStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSecondary,
    );

    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Theme.of(context).colorScheme.onSecondary,
                ),
            cursorColor: Colors.white,
            cupertinoOverrideTheme:
                const CupertinoThemeData(primaryColor: Colors.white),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _nameFormKey,
                  onChanged: () => setState(() {}),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: nameBorder,
                      focusedBorder: nameBorder,
                      enabledBorder: nameBorder,
                      isDense: true,
                      labelStyle: textFieldStyle,
                      hintStyle: textFieldStyle,
                    ),
                    validator: (String name) {
                      if (name.trim().isEmpty) return 'Name required';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RaisedBody(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: formWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectEventTypeCard extends StatelessWidget {
  /// Creates a card containing a dropdown button to select a different event.
  const _SelectEventTypeCard({
    Key key,
    @required this.eventType,
    @required this.onEventTypeSelected,
  })  : assert(eventType != null),
        assert(onEventTypeSelected != null),
        super(key: key);

  /// The [EventType] to display
  final EventType eventType;

  /// A callback function invoked when the user selects an event.
  final Function(EventType) onEventTypeSelected;

  /// Displays the dialog containg a list of event types that the user can
  /// select from.
  Future<void> selectEventType(BuildContext context) async {
    final EventType eventType = await showPlatformSelectionDialog<EventType>(
      context: context,
      selectedItem: this.eventType,
      material: true,
      items: EventType.values
          .map(
            (EventType type) => SelectionDialogItem<EventType>(
              name: eventTypeToString(type),
              value: type,
            ),
          )
          .toList(),
    );

    if (eventType != null) {
      onEventTypeSelected(eventType);
    }
  }

  @override
  Widget build(BuildContext context) {
    // The card containing the name of the selected event and the dropdown
    // button used to display the dialog.
    return Card(
      child: ListTile(
        title: Text(eventTypeToString(eventType)),
        trailing: Icon(FontAwesomeIcons.chevronDown),
        onTap: () => selectEventType(context),
      ),
    );
  }
}

class _SelectSubjectCard extends StatelessWidget {
  /// Creates a card containing a subject name and dropdown button to let users
  /// select a subject for an event.
  const _SelectSubjectCard({
    Key key,
    this.currentSubject,
    @required this.onSubjectSelected,
  }) : super(key: key);

  /// The selected subject
  final Subject currentSubject;

  /// A callback function invoked when a subject is selected.
  final Function(Subject) onSubjectSelected;

  /// Displays the dialog containing a list of subjects that the user can choose
  /// from.
  Future<void> selectSubject(BuildContext context) async {
    final Subject subject = await showSelectSubjectDialog(
      context: context,
      selectedSubject: currentSubject,
    );

    if (subject != null) onSubjectSelected(subject);
  }

  @override
  Widget build(BuildContext context) {
    // The Card containing the subject name and dropdown button used to display
    // the SelectSubject dialog.
    return IntrinsicHeight(
      child: Card(
        child: Row(
          children: <Widget>[
            Container(color: currentSubject?.color ?? Colors.grey, width: 4),
            Expanded(
              child: ListTile(
                title: Text(currentSubject?.name ?? 'Subject'),
                trailing: Icon(FontAwesomeIcons.chevronDown),
                onTap: () => selectSubject(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectDateCard extends StatelessWidget {
  /// Creates a card containg the shorthand form of a date and a dropdown button
  /// to let users select a new date.
  const _SelectDateCard({
    Key key,
    this.title,
    @required this.date,
    @required this.onDateSelected,
    this.fullDate = false,
  })  : assert(date != null),
        assert(onDateSelected != null),
        assert(fullDate != null),
        super(key: key);

  /// An optional title for the card.
  final String title;

  /// The date shown by the card.
  final DateTime date;

  /// A callback function invoked when the user selects a card.
  final Function(DateTime) onDateSelected;

  /// True if the date should be formatted as a full date instead of a shorthand
  /// date.
  final bool fullDate;

  /// Displays a date picker dialog and invokes the [onDateSelected] callback
  /// whenever the user selects a new date.
  Future<void> selectDate(BuildContext context) async {
    showPlatformDatePicker(context: context, initialDate: date)
        .listen(onDateSelected);
  }

  @override
  Widget build(BuildContext context) {
    /// The date text representing the provided date.
    final String dateString = fullDate
        ? MaterialLocalizations.of(context).formatFullDate(date)
        : MaterialLocalizations.of(context).formatMediumDate(date);
    // The card containing the date text and title.
    return Card(
      child: ListTile(
        title: Text(title ?? 'Date'),
        trailing: Text(dateString),
        onTap: () => selectDate(context),
      ),
    );
  }
}

class _SelectTimeCard extends StatelessWidget {
  /// Creates a card containing a title and text representing the provided time.
  const _SelectTimeCard({
    Key key,
    this.title,
    @required this.time,
    @required this.onTimeSelected,
  })  : assert(time != null),
        assert(onTimeSelected != null),
        super(key: key);

  /// An optional title for the card. Defaults to 'Time'
  final String title;

  /// The time to be displayed in this card.
  final TimeOfDay time;

  /// A callback function invoked when a new time is selected by the user.
  final Function(TimeOfDay) onTimeSelected;

  /// Displays a time picker dialog and invokes the [onTimeSelected] callback
  /// whenever the user selects a new time.
  Future<void> selectTime(BuildContext context) async {
    showPlatformTimePicker(context: context, initialTime: time)
        .listen(onTimeSelected);
  }

  @override
  Widget build(BuildContext context) {
    // The card containing the title text and the provided time.
    return Card(
      child: ListTile(
        title: Text(title ?? 'Time'),
        trailing: Text(MaterialLocalizations.of(context).formatTimeOfDay(time)),
        onTap: () => selectTime(context),
      ),
    );
  }
}

class _SelectSubjectAndEventRow extends StatelessWidget {
  /// Composition of the [_SelectSubjectCard] and the [_SelectEventTypeCard] for
  /// forms that display both in a row.
  const _SelectSubjectAndEventRow({
    Key key,
    @required this.currentSubject,
    @required this.onSubjectSelected,
    @required this.eventType,
    @required this.onEventTypeSelected,
  })  : assert(onSubjectSelected != null),
        assert(eventType != null),
        assert(onEventTypeSelected != null),
        super(key: key);

  /// The selected subject.
  final Subject currentSubject;

  /// A callback function invoked when the user selects a subject.
  final Function(Subject) onSubjectSelected;

  /// The selected event type
  final EventType eventType;

  /// A callback function invoked when the user selects an event type.
  final Function(EventType) onEventTypeSelected;

  @override
  Widget build(BuildContext context) {
    // A simple row displaying the select subject and select event card side by
    // side.
    return Row(
      children: <Widget>[
        Expanded(
          child: _SelectEventTypeCard(
            eventType: eventType,
            onEventTypeSelected: onEventTypeSelected,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SelectSubjectCard(
            onSubjectSelected: onSubjectSelected,
            currentSubject: currentSubject,
          ),
        ),
      ],
    );
  }
}

class _ContentField extends StatelessWidget {
  /// Abstraction for a text field
  const _ContentField({
    Key key,
    this.label,
    @required this.onTextChanged,
    this.focusNode,
    this.multiLine = true,
    this.icon,
  })  : assert(onTextChanged != null),
        assert(multiLine != null),
        super(key: key);

  /// The text field label
  final String label;
  final Function(String) onTextChanged;
  final FocusNode focusNode;
  final bool multiLine;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label ?? 'Content',
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        prefixIcon: icon,
      ),
      onChanged: onTextChanged,
      minLines: multiLine ? 2 : 1,
      maxLines: multiLine ? 2 : 1,
    );
  }
}

class _NumberField extends StatefulWidget {
  /// Abstraction for a text field
  const _NumberField({
    Key key,
    this.label,
    @required this.onNumberChanged,
    this.focusNode,
    this.icon,
    @required this.minNumber,
    @required this.maxNumber,
    this.defaultNumber,
    this.suffixText,
  })  : assert(onNumberChanged != null),
        assert(minNumber != null),
        assert(minNumber != null),
        assert(minNumber <= maxNumber),
        super(key: key);

  /// The text field label
  final String label;
  final Function(int) onNumberChanged;
  final FocusNode focusNode;
  final Widget icon;
  final int minNumber;
  final int maxNumber;
  final int defaultNumber;
  final String suffixText;

  @override
  __NumberFieldState createState() => __NumberFieldState();
}

class __NumberFieldState extends State<_NumberField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          widget.defaultNumber != null ? widget.defaultNumber.toString() : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String validator(String value) {
    if (value.isEmpty) return 'A number is required';
    final int intValue = int.parse(value);
    if (intValue < widget.minNumber || intValue > widget.maxNumber) {
      return 'Must be between ${widget.minNumber} and ${widget.maxNumber}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          labelText: widget.label ?? 'Content',
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          prefixIcon: widget.icon,
          suffixText: widget.suffixText,
        ),
        keyboardType: TextInputType.number,
        onChanged: (String val) => widget.onNumberChanged(int.parse(val)),
        validator: validator,
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    Key key,
    @required this.minimum,
    @required this.maximum,
    @required this.divisions,
    @required this.value,
    this.suffix = 'm',
    this.semanticSuffix = 'minutes',
    @required this.label,
    @required this.onValueChanged,
    this.inCard = true,
  })  : assert(minimum != null),
        assert(maximum != null),
        assert(divisions != null),
        assert(value != null),
        assert(suffix != null),
        assert(semanticSuffix != null),
        assert(label != null),
        assert(onValueChanged != null),
        assert(inCard != null),
        super(key: key);

  final double minimum;
  final double maximum;
  final int divisions;
  final int value;
  final String suffix;
  final String semanticSuffix;
  final String label;
  final Function(double) onValueChanged;
  final bool inCard;

  @override
  Widget build(BuildContext context) {
    Widget widget = Column(
      children: <Widget>[
        SizedBox(height: inCard ? 8 : 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label),
              // Semantics required to prevent <x>m to be
              // interpreted as x meters
              Text(
                '$value$suffix',
                semanticsLabel: '$value $semanticSuffix',
              ),
            ],
          ),
        ),
        Slider.adaptive(
          value: value.toDouble(),
          divisions: divisions,
          min: minimum,
          max: maximum,
          label: '$value$suffix',
          onChanged: onValueChanged,
        ),
      ],
    );
    if (inCard) {
      widget = Card(clipBehavior: Clip.none, child: widget);
    }
    return widget;
  }
}

class _RevisionPriorityInfoDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return showModal<void>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (_) => _RevisionPriorityInfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Revision Priority'),
      content: const Text(
        'This number is used to create more or less study sessions for your '
        'tests and exams based on how important they are.',
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('COOL'),
        ),
      ],
    );
  }
}

class _HomeworkForm extends StatefulWidget {
  const _HomeworkForm({
    Key key,
    @required this.name,
    @required this.onEventTypeSelected,
  })  : assert(name != null),
        super(key: key);

  final String name;
  final Function(EventType) onEventTypeSelected;

  @override
  _HomeworkFormState createState() => _HomeworkFormState();
}

class _HomeworkFormState extends State<_HomeworkForm> {
  Future<void> addHomework() async {
    if (subject == null) return Future<void>.error('A subject is required.');
    final HomeworkVM vm = context.read<HomeworkVM>();
    await vm.addHomework(
      name: widget.name,
      subject: subject,
      due: due,
      length: length,
      description: description,
    );
    Navigator.pop(context);
  }

  DateTime due = DateTime.now().add(const Duration(days: 1));
  Subject subject;
  Duration length = const Duration(minutes: 30);
  String description = '';

  void setSubject(Subject subject) {
    if (subject != null && this.subject != subject) {
      setState(() => this.subject = subject);
    }
  }

  void setDueDate(DateTime dueDate) {
    if (dueDate != null && dueDate != due) {
      setState(() => due = dueDate);
    }
  }

  void setLength(double length) {
    if (length != null && this.length.inMinutes != length) {
      setState(() => this.length = Duration(minutes: length.toInt()));
    }
  }

  void setDescription(String description) {
    if (description != null && this.description != description) {
      setState(() => this.description = description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SelectSubjectAndEventRow(
          currentSubject: subject,
          eventType: EventType.HOMEWORK,
          onEventTypeSelected: widget.onEventTypeSelected,
          onSubjectSelected: setSubject,
        ),
        _SelectDateCard(
          title: 'Due',
          date: due,
          onDateSelected: setDueDate,
          fullDate: true,
        ),
        _Slider(
          divisions: 15,
          label: 'Length',
          minimum: 15,
          maximum: 90,
          onValueChanged: setLength,
          value: length.inMinutes,
        ),
        const SizedBox(height: 4),
        _ContentField(label: 'Description', onTextChanged: setDescription),
      ],
    );
  }
}

class _ExamForm extends StatefulWidget {
  const _ExamForm({
    Key key,
    @required this.name,
    @required this.onEventTypeSelected,
  })  : assert(name != null),
        assert(onEventTypeSelected != null),
        super(key: key);

  final String name;
  final Function(EventType) onEventTypeSelected;

  @override
  _ExamFormState createState() => _ExamFormState();
}

class _ExamFormState extends State<_ExamForm> {
  Future<void> addExam() async {
    if (subject == null) return Future<void>.error('A subject is required.');

    final ExamsVM vm = context.read<ExamsVM>();
    await vm.addExam(
      name: widget.name,
      subject: subject,
      date: dateTime,
      length: length,
      seat: seat,
      location: location,
      priority: priority,
    );
    Navigator.pop(context);
  }

  Subject subject;
  DateTime dateTime = dateTimeWithTimeOfDay(
      DateTime.now().add(const Duration(days: 1)),
      const TimeOfDay(hour: 9, minute: 0));
  Duration length = const Duration(minutes: 90);
  String seat = '';
  String location = '';
  int priority = 3;

  void setSubject(Subject subject) {
    if (subject != null && this.subject != subject) {
      setState(() => this.subject = subject);
    }
  }

  void setDate(DateTime date) {
    if (date != null && dateTime != date) {
      setState(
        () => dateTime = dateTimeWithTimeOfDay(
          date,
          TimeOfDay.fromDateTime(dateTime),
        ),
      );
    }
  }

  void setTime(TimeOfDay time) {
    if (time != null && TimeOfDay.fromDateTime(dateTime) != time) {
      setState(() => dateTime = dateTimeWithTimeOfDay(dateTime, time));
    }
  }

  void setLength(Duration length) {
    if (length != null && this.length != length) {
      setState(() => this.length = length);
    }
  }

  void setSeat(String seat) {
    if (seat != null && this.seat != seat) {
      setState(() => this.seat = seat);
    }
  }

  void setLocation(String location) {
    if (location != null && this.location != location) {
      setState(() => this.location = location);
    }
  }

  Future<void> showRevisionPriorityDialog() async {
    await showModal<void>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (_) => _RevisionPriorityInfoDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SelectSubjectAndEventRow(
          currentSubject: subject,
          eventType: EventType.EXAM,
          onEventTypeSelected: widget.onEventTypeSelected,
          onSubjectSelected: setSubject,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _SelectDateCard(
                date: dateTime,
                onDateSelected: setDate,
                fullDate: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SelectTimeCard(
                onTimeSelected: setTime,
                time: TimeOfDay.fromDateTime(dateTime),
              ),
            ),
          ],
        ),
        _Slider(
          divisions: 29,
          label: 'Length',
          minimum: 10,
          maximum: 300,
          onValueChanged: (double length) => setLength(
            Duration(minutes: length.toInt()),
          ),
          value: length.inMinutes,
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Expanded(
              child: _ContentField(
                onTextChanged: setSeat,
                label: 'Seat',
                multiLine: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ContentField(
                onTextChanged: setLocation,
                label: 'Location',
                multiLine: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: _NumberField(
                onNumberChanged: (int value) => priority = value,
                label: 'Revision Priority',
                defaultNumber: priority,
                minNumber: 1,
                maxNumber: 5,
                suffixText: '1–5',
              ),
            ),
            IconButton(
              onPressed: () => _RevisionPriorityInfoDialog.show(context),
              icon: FaIcon(FontAwesomeIcons.infoCircle),
              tooltip: 'Priority Info',
            ),
          ],
        ),
      ],
    );
  }
}

class _TestForm extends StatefulWidget {
  const _TestForm({
    Key key,
    @required this.name,
    @required this.onEventTypeSelected,
  })  : assert(name != null),
        assert(onEventTypeSelected != null),
        super(key: key);

  final String name;
  final Function(EventType) onEventTypeSelected;

  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<_TestForm> {
  Future<void> addTest() async {
    if (subject == null) return Future<void>.error('A subject is required.');
    final ExamsVM vm = context.read<ExamsVM>();
    await vm.addTest(
      subject: subject,
      date: date,
      name: widget.name,
      content: content,
      priority: priority,
    );
    Navigator.pop(context);
  }

  Subject subject;
  DateTime date = DateTime.now().add(const Duration(days: 1));
  String content = '';
  int priority = 3;

  void setDate(DateTime date) {
    if (date != null && date != this.date) {
      setState(() => this.date = date);
    }
  }

  void setSubject(Subject subject) {
    if (subject != null && this.subject != subject) {
      setState(() => this.subject = subject);
    }
  }

  void setContent(String content) {
    if (content != null && this.content != content) {
      setState(() => this.content = content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SelectSubjectAndEventRow(
          currentSubject: subject,
          eventType: EventType.TEST,
          onEventTypeSelected: widget.onEventTypeSelected,
          onSubjectSelected: setSubject,
        ),
        _SelectDateCard(
          date: date,
          onDateSelected: setDate,
          fullDate: true,
        ),
        const SizedBox(height: 4),
        _ContentField(onTextChanged: setContent),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: _NumberField(
                onNumberChanged: (int value) => priority = value,
                label: 'Revision Priority',
                defaultNumber: priority,
                minNumber: 1,
                maxNumber: 5,
                suffixText: '1–5',
              ),
            ),
            IconButton(
              onPressed: () => _RevisionPriorityInfoDialog.show(context),
              icon: FaIcon(FontAwesomeIcons.infoCircle),
            ),
          ],
        ),
      ],
    );
  }
}
