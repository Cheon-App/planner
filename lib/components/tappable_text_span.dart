import 'package:flutter/material.dart';

WidgetSpan tappableTextSpan(
  BuildContext context, {
  @required String text,
  @required VoidCallback onTap,
  Color color,
}) {
  assert(text != null);
  return WidgetSpan(
    child: GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: color ?? Theme.of(context).colorScheme.onPrimary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
      ),
    ),
  );
}
