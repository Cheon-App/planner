// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animations/animations.dart';

// Project imports:
import 'package:cheon/constants.dart';
import 'package:cheon/models/selection_dialog_widget_item.dart';
import 'package:cheon/widgets/grid_selection_dialog.dart';

class SelectIconCard extends StatelessWidget {
  const SelectIconCard({
    Key key,
    @required this.icon,
    @required this.onIconChanged,
  }) : super(key: key);

  final IconData icon;
  final ValueChanged<IconData> onIconChanged;

  Future<void> _selectIcon(BuildContext context) async {
    final IconData icon = await showModal<IconData>(
      configuration: FadeScaleTransitionConfiguration(),
      context: context,
      builder: (BuildContext context) {
        return GridSelectionDialog<IconData>(
          defaultItem: this.icon,
          title: 'Select An Icon',
          items: subjectIconMap.values
              .map(
                (IconData i) => SelectionDialogWidgetItem<IconData>(
                  widget: Icon(i),
                  value: i,
                ),
              )
              .toList(),
        );
      },
    );
    if (icon != null) onIconChanged(icon);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Icon'),
        trailing: Icon(icon),
        onTap: () => _selectIcon(context),
      ),
    );
  }
}
