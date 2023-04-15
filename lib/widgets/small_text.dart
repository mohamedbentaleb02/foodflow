import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  SmallText({
    super.key,
    this.color = Colors.black54,
    required this.text,
    this.size = 12,
    this.height = 1.2,
  });
  Color? color;
  final String text;
  double size;
  double height;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'rubik',
        fontSize: size,
        height: height,
        color: color,
      ),
    );
  }
}
