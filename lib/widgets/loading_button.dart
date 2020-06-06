import 'package:cheon/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingButton extends StatelessWidget {
  /// Creates a button that shows a text or a loading indicator while active
  const LoadingButton({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.loading,
  })  : assert(text != null),
        assert(loading != null),
        super(key: key);

  /// The text shown while the button is inactive.
  final String text;

  /// A void function invoked when the button is tapped.
  final VoidCallback onTap;

  /// True if the button is loading.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).buttonColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: loading
                ? SpinKitWave(
                    duration: DURATION_EXTRA_LONG,
                    size: 24,
                    itemBuilder: (BuildContext context, int _) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
