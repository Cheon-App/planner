// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cheon/cheon_app.dart';

class CustomSelectionDialog extends StatelessWidget {
  /// A dialog used to select an item from a list of given widgets.
  const CustomSelectionDialog({
    Key key,
    @required this.items,
    this.title,
    this.action,
  })  : assert(items != null),
        assert(action == null || title != null),
        super(key: key);

  final List<Widget> items;
  final String title;

  /// Usually an [IconButton]
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (title != null) Text(title),
          if (action != null) Semantics(container: true, child: action),
        ],
      ),
      children: items,
      contentPadding: const EdgeInsets.only(bottom: 8),
      titlePadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
    );
  }
}

class CustomSelectionDialogAction extends StatelessWidget {
  const CustomSelectionDialogAction({
    Key key,
    @required this.onPressed,
    @required this.tooltip,
  })  : assert(onPressed != null),
        assert(tooltip != null),
        super(key: key);
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FontAwesomeIcons.plus),
      iconSize: 20,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}

class CustomSelectionDialogItem extends StatelessWidget {
  const CustomSelectionDialogItem({
    Key key,
    @required this.selected,
    @required this.text,
    @required this.onTap,
  })  : assert(selected != null),
        assert(text != null),
        assert(onTap != null),
        super(key: key);

  final bool selected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CheonApp.borderRadius),
          side: selected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
