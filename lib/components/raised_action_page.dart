import 'package:cheon/components/primary_action_button.dart';
import 'package:cheon/components/raised_body.dart';
import 'package:cheon/components/tap_to_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RaisedActionPage extends StatelessWidget {
  /// Abstraction for a common page design containing a coloured app bar, an
  /// edit and delete button, and a primary action button.
  const RaisedActionPage({
    Key key,
    @required this.appBarTitle,
    @required this.color,
    this.extraAction,
    this.editMode,
    this.onDelete,
    this.onEditModeChanged,
    this.primaryActionTitle,
    this.primaryActionEnabled = true,
    this.onPrimaryActionTap,
    @required this.child,
    this.scaffoldKey,
  })  : assert(appBarTitle != null),
        assert(color != null),
        assert(
          editMode == null || (onDelete != null && onEditModeChanged != null),
        ),
        assert(
          primaryActionTitle == null ||
              (primaryActionEnabled != null && onPrimaryActionTap != null),
        ),
        assert(child != null),
        super(key: key);

  final String appBarTitle;
  final Color color;
  final bool editMode;
  final Widget extraAction;
  final Function onEditModeChanged;
  final VoidCallback onDelete;
  final String primaryActionTitle;
  final bool primaryActionEnabled;
  final VoidCallback onPrimaryActionTap;
  final Widget child;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final bool showActionButton = primaryActionTitle != null;
    final List<Widget> actions = <Widget>[];
    if (extraAction != null) actions.add(extraAction);
    actions.add(IconButton(
      icon: Icon(
        editMode ? FontAwesomeIcons.check : FontAwesomeIcons.edit,
      ),
      onPressed: onEditModeChanged,
    ));

    return TapToDismiss(
      child: Scaffold(
        backgroundColor: color,
        extendBody: true,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
          ),
          backgroundColor: color,
          brightness: Brightness.dark,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          actions: actions,
        ),
        body: RaisedBody(
          child: Padding(
            padding: showActionButton
                ? const EdgeInsets.only(bottom: 80)
                : const EdgeInsets.all(0),
            child: child,
          ),
        ),
        floatingActionButton: editMode
            ? FloatingActionButton(
                child: const Icon(FontAwesomeIcons.trashAlt),
                onPressed: onDelete,
                tooltip: 'Delete',
              )
            : null,
        bottomNavigationBar: showActionButton
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryActionButton(
                  text: primaryActionTitle,
                  onTap: primaryActionEnabled ? onPrimaryActionTap : null,
                ),
              )
            : null,
      ),
    );
  }
}
