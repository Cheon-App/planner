// Flutter imports:
import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({Key key, this.color = Colors.black}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 18,
        width: 26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (int i = 0; i < 3; i++) _Bar(color: color)],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({Key key, @required this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5,
      decoration: ShapeDecoration(color: color, shape: StadiumBorder()),
    );
  }
}
