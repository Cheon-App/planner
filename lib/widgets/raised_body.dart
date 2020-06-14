// Flutter imports:
import 'package:flutter/material.dart';

class RaisedBody extends StatelessWidget {
  /// Creates a plain background with rounded corners in the top right and left
  const RaisedBody({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      // Rounded corners
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      child: child,
    );
  }
}
