// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';
import 'package:cheon/utils.dart';

class DayToggle extends StatelessWidget {
  const DayToggle({
    Key key,
    @required this.onPressed,
    @required this.isSelected,
  }) : super(key: key);

  final Function(int) onPressed;
  final bool Function(int) isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 8) / 7;

        return ToggleButtons(
          constraints: BoxConstraints(
            minHeight: 48,
            minWidth: itemWidth,
          ),
          onPressed: onPressed,
          children: List.generate(
            7,
            (i) => Semantics(
              button: true,
              checked: isSelected(i),
              child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                child: Text(
                  dayToShortString(i + 1),
                  semanticsLabel: dayToString(i + 1),
                ),
              ),
            ),
          ),
          isSelected: List.generate(7, isSelected),
          borderRadius: BorderRadius.circular(CheonApp.borderRadius),
        );
      },
    );
  }
}
