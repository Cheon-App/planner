// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  /// Creates an animated loading indicator.
  const LoadingIndicator({Key key, this.color}) : super(key: key);

  /// The colour of the loading indicator. Defaults to the app accentColor.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRipple(color: color ?? Theme.of(context).accentColor),
    );
  }
}
