// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sticky_headers/sticky_headers.dart';

class StickySection extends StatelessWidget {
  /// Creates a list header that remains visible until the the [children] are
  /// out of view
  const StickySection({
    Key key,
    @required this.name,
    @required this.children,
    this.warning = false,
  })  : assert(name != null),
        assert(children != null),
        assert(warning != null),
        super(key: key);

  final String name;
  final bool warning;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: _TimeFrame(name: name, warning: warning),
      content: ListView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(0),
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) => children[index],
      ),
    );
  }
}

class _TimeFrame extends StatelessWidget {
  const _TimeFrame({Key key, @required this.name, @required this.warning})
      : assert(name != null),
        assert(warning != null),
        super(key: key);
  final String name;
  final bool warning;

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: Text(
          name,
          style: warning
              ? Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.red)
              : Theme.of(context).textTheme.headline5,
        ),
      );
}
