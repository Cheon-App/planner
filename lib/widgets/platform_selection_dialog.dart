// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:animations/animations.dart';

// Project imports:
import 'package:cheon/app.dart';
import 'package:cheon/utils.dart';

/// Inflates a dialog containing a list of given items.
/// Optionally provide a title that appears at the top of the dialog.
/// The optional [selectedItem] is highlighted on material themed devices.
Future<T> showPlatformSelectionDialog<T>({
  @required BuildContext context,
  @required List<SelectionDialogItem<T>> items,
  // bool isAction = true,
  T selectedItem,
  final String title,
  bool isAction = false,
  bool material,
}) async {
  assert(context != null);
  assert(items != null);
  assert(isAction != null);
  material ??= isMaterial(context);

  if (material) {
    return showModal<T>(
      context: context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) {
        return _SelectionDialog<T>(
          title: title,
          items: items,
          selectedItem: selectedItem,
        );
      },
    );
  } else {
    if (isAction) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: title != null ? Text(title) : null,
            actions: items
                .map(
                  (SelectionDialogItem<T> item) => CupertinoActionSheetAction(
                    child: Text(item.name),
                    isDefaultAction: item.value == selectedItem,
                    onPressed: () => Navigator.pop(context, item.value),
                  ),
                )
                .toList(),
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        },
      );
    } else {
      return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            actions: items
                .map(
                  (SelectionDialogItem<T> item) => CupertinoDialogAction(
                    child: Text(item.name),
                    isDefaultAction: item.value == selectedItem,
                    onPressed: () => Navigator.pop(context, item.value),
                  ),
                )
                .toList()
                  ..add(CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                    isDestructiveAction: true,
                  )),
          );
        },
      );
    }
  }
}

/// Provide a list of items, a return type and optionally the value of a
/// selected item
/// Each item needs a name
class SelectionDialogItem<T> {
  SelectionDialogItem({@required this.name, @required this.value})
      : assert(name != null),
        assert(value != null);

  final String name;
  final T value;
}

class _SelectionDialog<T> extends StatelessWidget {
  const _SelectionDialog(
      {Key key, @required this.items, this.selectedItem, this.title})
      : assert(items != null),
        super(key: key);

  final List<SelectionDialogItem<T>> items;
  final T selectedItem;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title != null ? Text(title) : null,
      children: items
          .map(
            (SelectionDialogItem<T> item) => _SelectionItem<T>(
              item: item,
              selected: item.value == selectedItem,
            ),
          )
          .toList(),
    );
  }
}

class _SelectionItem<T> extends StatelessWidget {
  const _SelectionItem({
    Key key,
    @required this.selected,
    @required this.item,
  })  : assert(selected != null),
        assert(item != null),
        super(key: key);

  final bool selected;
  final SelectionDialogItem<T> item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: selected
          ? Material(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(App.borderRadius),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                onTap: () => Navigator.pop(context, item.value),
              ),
            )
          : Material(
              borderRadius: BorderRadius.circular(App.borderRadius),
              clipBehavior: Clip.antiAlias,
              type: MaterialType.transparency,
              child: ListTile(
                title: Text(item.name),
                onTap: () => Navigator.pop(context, item.value),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
    );
  }
}
