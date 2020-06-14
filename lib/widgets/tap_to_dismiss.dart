// Flutter imports:
import 'package:flutter/material.dart';

// Inspired by https://stackoverflow.com/questions/55306855/hide-keyboard-on-scroll-in-flutter

class TapToDismiss extends StatelessWidget {
  /// Creates a widget that dismisses a virtual keyboard when the surrounding
  /// area is swiped as ios devices do not have a back button
  const TapToDismiss({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
