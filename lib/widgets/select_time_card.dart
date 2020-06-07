import 'package:cheon/widgets/platform_date_time_picker.dart';
import 'package:flutter/material.dart';

class SelectTimeCard extends StatelessWidget {
  /// Creates a card containing a title and text representing the provided time.
  const SelectTimeCard({
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
