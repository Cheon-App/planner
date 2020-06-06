import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.message = 'Something went wrong. If this message persists please '
        'email us at contact@cheon.app or join our '
        'community Discord group for support.',
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Center(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(message),
          ))
        : const SizedBox.shrink();
  }
}
