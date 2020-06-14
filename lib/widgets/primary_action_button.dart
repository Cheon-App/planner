// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/app.dart';

class PrimaryActionButton extends StatelessWidget {
  /// Creates a button typically representing the most important action
  /// available
  const PrimaryActionButton({
    Key key,
    @required this.onTap,
    this.text,
    this.child,
    this.color,
    this.textColor,
  })  : assert(
            (text != null && child == null) || (child != null && text == null)),
        assert(
          (textColor == null && color == null) ||
              (color != null && textColor != null),
        ),
        super(key: key);
  final VoidCallback onTap;
  final String text;
  final Widget child;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        color: color ??
            Theme.of(context)
                .colorScheme
                .secondary
                .withOpacity(onTap != null ? 1 : 0.5),
        borderRadius: BorderRadius.circular(App.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: text != null
                ? Text(
                    text,
                    style: textColor ??
                        Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
