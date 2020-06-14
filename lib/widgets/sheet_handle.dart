// Flutter imports:
import 'package:flutter/material.dart';

/// Creates a bottom sheet handle placed just below the top of the sheet to
/// indicate that the sheet is draggable
class SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      width: 48,
      child: Material(
        color: Colors.grey,
        shape: const StadiumBorder(),
      ),
    );
  }
}
