import 'package:flutter/material.dart';

class TopOfScrollable extends StatefulWidget {
  const TopOfScrollable({
    Key key,
    @required this.atTop,
    @required this.notAtTop,
    @required this.child,
  }) : super(key: key);
  final VoidCallback atTop;
  final VoidCallback notAtTop;
  final Widget child;

  @override
  _TopOfScrollableState createState() => _TopOfScrollableState();
}

class _TopOfScrollableState extends State<TopOfScrollable> {
  bool _atTop = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // A nested scrollable triggered this notification and should be ignored
        if (notification.depth != 0) return false;

        if (notification.metrics.pixels <= 0 && !_atTop) {
          _atTop = true;
          widget.atTop();
        }
        if (notification.metrics.pixels > 0 && _atTop) {
          _atTop = false;
          widget.notAtTop();
        }
        return false;
      },
      child: widget.child,
    );
  }
}
