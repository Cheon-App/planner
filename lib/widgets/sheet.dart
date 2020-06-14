// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/widgets/sheet_handle.dart';

class Sheet {
  /// Creates a Material bottom sheet with a blurred background
  static Future<T> showModalBottomSheet<T>({
    @required BuildContext context,
    @required Widget child,
    Duration animationDuration,
    bool showHandle = true,
    String title,
    bool fullSize = true,
  }) {
    assert(showHandle != null);
    assert(fullSize != null);
    final _BottomSheetModalRoute<T> route = _BottomSheetModalRoute<T>(
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showHandle
              ? Column(
                  children: <Widget>[
                    const SizedBox(height: 12),
                    Align(alignment: Alignment.center, child: SheetHandle()),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox.shrink(),
          title != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          fullSize ? Expanded(child: child) : child
        ],
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      animationDuration: animationDuration ?? const Duration(milliseconds: 200),
    );

    return Navigator.push<T>(context, route);
  }
}

/// The constraints of this sheet
class _BottomSheetLayout extends SingleChildLayoutDelegate {
  _BottomSheetLayout(this.progress);
  final double progress;

  // Uses the screen height to determine how high the bottom sheet should extend
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double multiplier;

    if (constraints.maxHeight < 500) {
      multiplier = 0.95;
    } else if (constraints.maxHeight < 700) {
      multiplier = 0.9;
    } else {
      multiplier = 0.8;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight * multiplier,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_BottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _BottomSheetModalRoute<T> extends PopupRoute<T> {
  _BottomSheetModalRoute({
    this.builder,
    this.barrierLabel,
    this.animationDuration,
  });

  final WidgetBuilder builder;
  final Duration animationDuration;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.1);

  @override
  bool get barrierDismissible => true;

  @override
  String barrierLabel;

  AnimationController _animationController;
  CurvedAnimation sheetAnimation;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    _animationController.duration = animationDuration;
    sheetAnimation = CurvedAnimation(
      parent: _animationController,
      // Entrance curve
      curve: Curves.easeOut,
      // Exit curve
      reverseCurve: Curves.linear,
    )..addStatusListener(
        (AnimationStatus animationStatus) {
          if (animationStatus == AnimationStatus.completed) {
            sheetAnimation.curve = Curves.linear;
          }
        },
      );
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: AnimatedBuilder(
            animation: sheetAnimation,
            builder: (BuildContext context, Widget child) =>
                CustomSingleChildLayout(
              delegate: _BottomSheetLayout(sheetAnimation.value),
              child: BottomSheet(
                animationController: _animationController,
                onClosing: () => Navigator.pop(context),
                builder: (BuildContext context) => Material(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Builder(builder: builder),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => animationDuration;
}
