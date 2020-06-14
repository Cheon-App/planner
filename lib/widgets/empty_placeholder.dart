// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:cheon/constants.dart';

class EmptyPlaceholder extends StatelessWidget {
  /// Creates an image showing an illustration of a person holding an empty box
  /// to signify that there is no content available.
  const EmptyPlaceholder({
    Key key,
    this.text,
    this.svgPath,
  }) : super(key: key);

  final String text;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: const Alignment(0, -0.4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FittedBox(
              child: SvgPicture.asset(
                svgPath ?? IMG_EMPTY,
                allowDrawingOutsideViewBox: false,
                placeholderBuilder: (_) => const SizedBox(width: 1, height: 1),
              ),
            ),
            text != null
                ? Column(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Text(
                        text,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
