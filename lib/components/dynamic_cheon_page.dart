import 'package:cheon/components/cheon_page.dart';
import 'package:cheon/utils.dart';
import 'package:flutter/material.dart';

class DynamicCheonPage extends StatelessWidget {
  /// Wraps it's child in a [CheonPage] or the default [Scaffold] based on the
  /// given [inHomePage] option.
  /// This is useful for pages that can either appear in the home page or as
  /// it's own page if the user has chosen to move the location of the page
  /// outside of the home page.
  const DynamicCheonPage({
    Key key,
    @required this.inHomePage,
    @required this.title,
    @required this.child,
    this.floatingActionButton,
    this.actions,
    this.centerTitle,
  })  : assert(inHomePage != null),
        assert(title != null),
        assert(child != null),
        super(key: key);

  /// True if the content resides in the home page.
  final bool inHomePage;

  /// The [AppBar] title of the page.
  final String title;

  /// The widget placed inside the new page.
  final Widget child;

  /// An optional floating action button appearing at the bottom of the screen.
  final Widget floatingActionButton;

  /// The [AppBar] actions present on the standard page or the [CheonPage]
  final List<Widget> actions;

  /// True if the title should be centered. Overrides the platform default.
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    /// Returns a [CheonPage] if [inHomePage] is true otherwise it returns a
    /// [Scaffold] without the [CheonAppBar]
    return inHomePage
        ? CheonPage(child: child, actions: actions)
        : Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: actions,
              centerTitle:
                  centerTitle ?? actions.length <= 2 && !isMaterial(context),
            ),
            floatingActionButton: floatingActionButton,
            body: child,
          );
  }
}
