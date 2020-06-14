import 'package:cheon/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarTheme extends StatelessWidget {
  const StatusBarTheme({
    Key key,
    @required this.brightness,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: invertedBrigntness(brightness),
        statusBarBrightness: brightness,
      ),
      child: child,
    );
  }
}
