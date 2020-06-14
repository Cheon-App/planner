// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animations/animations.dart';

// Project imports:
import 'package:cheon/models/selection_dialog_widget_item.dart';
import 'package:cheon/widgets/grid_selection_dialog.dart';

class SelectColorCard extends StatelessWidget {
  const SelectColorCard({
    Key key,
    @required this.color,
    @required this.onColorChanged,
  }) : super(key: key);

  final Color color;
  final ValueChanged<Color> onColorChanged;

  Future<void> _selectColor(BuildContext context) async {
    final Color color = await showModal<Color>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return GridSelectionDialog<Color>(
          defaultItem: this.color,
          title: 'Select A Colour',
          items: Colors.primaries
              .map(
                (c) => SelectionDialogWidgetItem<Color>(
                  widget: Material(color: c, shape: CircleBorder()),
                  value: c,
                ),
              )
              .toList(),
        );
      },
    );

    if (color != null) onColorChanged(color);
  }

  Widget _dot() {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Colour'),
        onTap: () => _selectColor(context),
        trailing: _dot(),
      ),
    );
  }
}
