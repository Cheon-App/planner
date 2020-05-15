import 'package:cheon/constants.dart';
import 'package:flutter/material.dart';

class LinearProgressBar extends ImplicitlyAnimatedWidget {
  /// Creates a styled progress bar that animated declaratively using
  /// [ImplicitlyAnimatedWidget].
  const LinearProgressBar({
    Key key,
    @required this.fraction,
    @required this.color,

    /// The animation curve i.e. a profile for the velocity of the animation
    /// from start to end. default to Curves.linear.
    Curve curve = Curves.linear,

    /// The duration of the animation. Defaults to DURATION_MEDIUM.
    Duration duration = DURATION_MEDIUM,

    /// A callback function invoked when the animation ends
    VoidCallback onEnd,
    this.shape = const StadiumBorder(),
  })  : assert(fraction >= 0 && fraction <= 1),
        assert(curve != null),
        assert(color != null),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// The shaded fraction of the progrss bar rangin from zero inclusive to one
  /// inclusive
  final double fraction;

  /// The colour of the progress bar. A semi-opaque variant of this is used for
  /// the incomplete fraction of the progress bar.
  final Color color;

  /// The shape of the progress bar. Defaults to a [StadiumBorder] which
  /// provides completely rounded corners.
  final ShapeBorder shape;

  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState
    extends ImplicitlyAnimatedWidgetState<LinearProgressBar> {
  /// The 'inbetween' object that stores the start and end state of the
  /// animation i.e. the start and end fraction of the progress bar.
  Tween<double> _fraction;

  /// The animation object used to control the animation.
  Animation<double> _fractionAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    // Initialises the _fraction tween with the start value provided in the
    // widget constructor.
    _fraction = visitor(
      _fraction,
      widget.fraction,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  void didUpdateTweens() {
    // Runs the animation if the widget gets rebuild with a new fraction.
    _fractionAnimation = animation.drive(_fraction);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${(widget.fraction * 100).truncate()}% complete',
      child: SizedBox(
        width: double.infinity,
        child: Material(
          shape: widget.shape,
          // The background color of the progress bar
          color: widget.color.withOpacity(0.5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _fractionAnimation,
              builder: (BuildContext context, Widget child) {
                // The shaded portion of the progress bar. It's size is animated
                // implicitly by invoking this builder everytime the
                // _fractionAnimation updates.
                return FractionallySizedBox(
                  widthFactor: _fractionAnimation.value,
                  child: SizedBox(
                    height: 16,
                    child: Material(color: widget.color, shape: widget.shape),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
