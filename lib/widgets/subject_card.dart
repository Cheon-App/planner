import 'package:cheon/app.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  /// Creates a card containing subject information
  const SubjectCard({
    Key key,
    @required this.color,
    @required this.title,
    this.trailing,
    this.trailingWidget,
    this.trailingSubtitle,
    this.subtitle,
    @required this.onTap,
    this.bottom,
    this.dense = false,
    this.margin,
    this.endPadding = true,
  })  : assert(dense != null),
        assert(trailing == null || trailingWidget == null),
        assert(
          dense == false || !(subtitle == null && trailingSubtitle == null),
          'SubjectCard cannot be dense without a subtitle or trailingSubtitle',
        ),
        super(key: key);

  final Color color;
  final String title;
  final String trailing;
  final Widget trailingWidget;
  final Widget trailingSubtitle;
  final String subtitle;
  final Widget bottom;
  final VoidCallback onTap;
  final bool dense;
  final EdgeInsetsGeometry margin;
  final bool endPadding;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool oneRow = subtitle == null && trailingSubtitle == null;
    return IntrinsicHeight(
      child: Card(
        color: isDark ? Colors.transparent : color.withOpacity(0.1),
        shape: isDark
            ? Theme.of(context).cardTheme.shape
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(App.borderRadius),
              ),
        margin: margin,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              // Colour indicator
              Container(color: color, width: 4),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: dense ? 2 : oneRow ? 8 : 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Title
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Trailing text or widget
                        trailingWidget ?? const SizedBox.shrink(),
                        trailing != null
                            ? Text(
                                trailing,
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: dense ? 0 : 4),
                    // Subtitle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        subtitle != null
                            ? Text(
                                subtitle,
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            : const SizedBox.shrink(),
                        trailingSubtitle ?? const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: dense ? 0 : 4),
                    bottom ?? const SizedBox.shrink(),
                    bottom != null
                        ? SizedBox(height: dense ? 4 : 8)
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              SizedBox(width: endPadding ? 8 : 0),
            ],
          ),
        ),
      ),
    );
  }
}
