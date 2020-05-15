import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SelectionDialogWidgetItem<T> extends Equatable {
  /// Represents an option in a selection dialog
  const SelectionDialogWidgetItem({@required this.widget, @required this.value})
      : assert(widget != null),
        assert(value != null);

  /// The widget being shown by this item
  final Widget widget;

  /// The value this widget represents
  final T value;

  @override
  List<Object> get props => <Object>[value];
}
