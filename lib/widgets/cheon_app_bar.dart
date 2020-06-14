// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cheon/widgets/menu_icon.dart';

class CheonAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a Material Design [AppBar] with the title set to Cheon.
  const CheonAppBar({Key key, this.actions}) : super(key: key);

  /// A  list of widgets diplayed at the end of the [AppBar].
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // The action buttons displayed at the end of the AppBar.
      actions: actions,
      // Prevents the title from centering itself on IOS as it isn't consistent
      // if more than two actions are present.
      centerTitle: false,
      // Prevents a back button or navigation drawer menu button from appearing
      // unexpectedly.
      automaticallyImplyLeading: false,
      // Prevents screen readers from reading this as it's the App name and
      // not specific to a part of the app.
      excludeHeaderSemantics: true,
      leading: IconButton(
        icon: MenuIcon(color: Theme.of(context).colorScheme.onBackground),
        iconSize: 32,
        onPressed: Scaffold.of(context).openDrawer,
        tooltip: MaterialLocalizations.of(context).drawerLabel,
      ),

      title: ExcludeSemantics(
        // The title of the app bar. In this case it's the app name.
        child: Text(
          'Cheon',
          // Uses the same font family as the logo.
          style: TextStyle(
            fontFamily: 'Orbitron',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  /// The [Scaffold] widget [AppBar]s are typically placed into requires a
  /// widget that implements [PreferredSizeWidget] in order for it to determine
  /// how much space it should allocate.
  /// For an [AppBar] with no widget directly below it i.e. a [TabBar], this can
  /// be set to the default height of [kToolbarHeight]
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
