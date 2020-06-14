// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/widgets/cheon_app_bar.dart';

class CheonPage extends StatelessWidget {
  /// Creates a [CheonAppBar] with a provided widget underneath.
  /// Pages in the home page can use this widget.
  const CheonPage({Key key, @required this.child, this.actions})
      : assert(child != null),
        super(key: key);

  /// The widget placed below the [CheonAppBar].
  final Widget child;

  /// The buttons shown at the end of the [CheonAppBar].
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CheonAppBar(actions: actions),
        Expanded(child: child),
      ],
    );
  }
}
