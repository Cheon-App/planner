// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';

// Mimics an actual app to enable widgets to operate correctly
Widget testableWidget({@required Widget child}) => MaterialApp(
      home: child,
      theme: CheonApp.theme(isDark: false),
    );

const String emptyString = '';
