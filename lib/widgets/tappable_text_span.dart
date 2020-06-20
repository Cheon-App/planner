// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TappableTextSpan extends TextSpan {
  TappableTextSpan(
    BuildContext context, {
    @required String text,
    VoidCallback onTap,
    Color color,
  }) : super(
          recognizer: TapGestureRecognizer()..onTap = onTap,
          text: text,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: color ?? Theme.of(context).colorScheme.onPrimary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
        );
}
