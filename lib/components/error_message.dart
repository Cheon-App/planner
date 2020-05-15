import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.message = 'Something went wrong. If you keep seeing this message then '
        'feel free to pop us an email at contact@cheon.app or join our '
        'community Discord group for support.',
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Center(child: Text(message))
        : const SizedBox.shrink();
  }
}
