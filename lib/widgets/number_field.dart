// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/utils.dart';

class NumberField extends StatefulWidget {
  /// Abstraction for a text field
  const NumberField({
    Key key,
    this.label,
    @required this.onNumberChanged,
    this.focusNode,
    this.icon,
    @required this.minNumber,
    @required this.maxNumber,
    this.defaultNumber,
    this.suffixText,
  })  : assert(onNumberChanged != null),
        assert(minNumber != null),
        assert(minNumber != null),
        assert(minNumber <= maxNumber),
        super(key: key);

  /// The text field label
  final String label;
  final Function(int) onNumberChanged;
  final FocusNode focusNode;
  final Widget icon;
  final int minNumber;
  final int maxNumber;
  final int defaultNumber;
  final String suffixText;

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          widget.defaultNumber != null ? widget.defaultNumber.toString() : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String validator(String value) {
    if (value.isEmpty) return 'A number is required';
    final int intValue = int.parse(value);
    if (intValue < widget.minNumber || intValue > widget.maxNumber) {
      return 'Must be between ${widget.minNumber} and ${widget.maxNumber}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          labelText: widget.label ?? 'Content',
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          prefixIcon: widget.icon,
          suffixText: widget.suffixText,
        ),
        inputFormatters: [numberInputFormatter],
        keyboardType: TextInputType.number,
        onChanged: (String val) => widget.onNumberChanged(int.parse(val)),
        validator: validator,
      ),
    );
  }
}
