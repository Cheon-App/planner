import 'package:flutter/material.dart';

class NumberDialog extends StatefulWidget {
  const NumberDialog({
    Key key,
    @required this.title,
    @required this.minimum,
    @required this.maximum,
    this.suffixText,
    this.initialValue,
  })  : assert(title != null),
        super(key: key);

  final int initialValue;
  final int minimum;
  final int maximum;
  final String title;
  final String suffixText;

  @override
  _NumberDialogState createState() => _NumberDialogState();
}

class _NumberDialogState extends State<NumberDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String validator(String value) {
    if (value.isEmpty) return 'A number is required';
    final int intValue = int.parse(value);
    if (intValue < widget.minimum || intValue > widget.maximum) {
      return 'Must be between ${widget.minimum} and ${widget.maximum}';
    }
    return null;
  }

  void submit() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context, int.parse(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        autovalidate: true,
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          validator: validator,
          decoration: InputDecoration(suffixText: widget.suffixText),
          autofocus: true,
        ),
      ),
      actions: <Widget>[
        FlatButton(child: const Text('CONFIRM'), onPressed: submit),
      ],
    );
  }
}
