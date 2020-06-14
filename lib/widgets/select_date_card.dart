// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/widgets/platform_date_time_picker.dart';

class SelectDateCard extends StatelessWidget {
  /// Creates a card containg the shorthand form of a date and a dropdown button
  /// to let users select a new date.
  const SelectDateCard({
    Key key,
    this.title,
    @required this.date,
    @required this.onDateSelected,
    this.fullDate = false,
    this.enabled = true,
    this.isRequired = false,
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

  /// True if the card is interactable
  final bool enabled;

  final bool isRequired;

  /// Displays a date picker dialog and invokes the [onDateSelected] callback
  /// whenever the user selects a new date.
  Future<void> selectDate(BuildContext context) async {
    showPlatformDatePicker(context: context, initialDate: date).listen((date) {
      if (date != null) onDateSelected(date);
    });
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
        title: Text((title ?? 'Date') + (isRequired ? '*' : '')),
        trailing: Text(dateString),
        onTap: () => selectDate(context),
        enabled: enabled,
      ),
    );
  }
}
