import 'package:cheon/app.dart';
import 'package:flutter/material.dart';

// Mimics an actual app to enable widgets to operate correctly
Widget testableWidget({@required Widget child}) => MaterialApp(
      home: child,
      theme: App.theme(isDark: false),
    );

const String emptyString = '';
