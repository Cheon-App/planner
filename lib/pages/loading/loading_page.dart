import 'package:flutter/material.dart';
import 'package:cheon/widgets/loading_indicator.dart';

class LoadingPage extends StatelessWidget {
  /// Creates a page containing a loading indicator in its center.
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: LoadingIndicator());
}
