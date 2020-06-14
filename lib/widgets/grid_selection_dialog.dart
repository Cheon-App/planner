// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/app.dart';
import 'package:cheon/models/selection_dialog_widget_item.dart';

class GridSelectionDialog<T> extends StatefulWidget {
  /// Creates a dialog containing [items] arranged in a four column grid
  const GridSelectionDialog(
      {Key key, this.defaultItem, @required this.items, this.title})
      : assert(items != null),
        super(key: key);

  final T defaultItem;
  final List<SelectionDialogWidgetItem<T>> items;
  final String title;

  @override
  _GridSelectionDialogState<T> createState() => _GridSelectionDialogState<T>();
}

class _GridSelectionDialogState<T> extends State<GridSelectionDialog<T>> {
  T currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = widget.defaultItem;
  }

  void setCurrentItem(T item) => setState(() => currentItem = item);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text(widget.title) : null,
      content: SizedBox(
        width: 100,
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          primary: false,
          semanticChildCount: widget.items.length,
          children: widget.items
              .map(
                (SelectionDialogWidgetItem<T> g) => _SelectionOption(
                  child: g.widget,
                  onTap: () => setCurrentItem(g.value),
                  selected: g.value == currentItem,
                ),
              )
              .toList(),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 20,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, currentItem),
        ),
      ],
    );
  }
}

class _SelectionOption extends StatelessWidget {
  const _SelectionOption({
    Key key,
    @required this.selected,
    @required this.onTap,
    @required this.child,
  })  : assert(selected != null),
        assert(onTap != null),
        super(key: key);

  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(App.borderRadius),
          side: selected
              ? BorderSide(color: Theme.of(context).colorScheme.secondary)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(8), child: child),
        ),
      ),
    );
  }
}
