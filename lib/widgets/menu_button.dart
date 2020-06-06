import 'package:cheon/widgets/menu_icon.dart';
import 'package:cheon/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: MenuIcon(color: Theme.of(context).colorScheme.onBackground),
      iconSize: 32,
      onPressed: context.findAncestorStateOfType<HomePageState>().openDrawer,
      tooltip: MaterialLocalizations.of(context).drawerLabel,
    );
  }
}
