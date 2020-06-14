// Flutter imports:
import 'package:flutter/material.dart';

class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({
    Key key,
    @required this.priority,
    @required this.color,
  })  : assert(priority != null),
        assert(color != null),
        super(key: key);
  final int priority;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$priority out of 5',
      child: Row(
        children: <Widget>[
          for (int i = 0; i < 5; i++)
            Container(
              height: 12,
              width: 12,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 1),
                borderRadius: BorderRadius.circular(4),
                color: i < priority ? color : Colors.transparent,
              ),
            )
        ],
      ),
    );
  }
}
