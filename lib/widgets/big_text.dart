import 'package:flutter/cupertino.dart';

class BigText extends StatelessWidget {
  BigText(
      {super.key,
      this.color = const Color(0xFFccc7c5),
      required this.text,
      this.fntWight = FontWeight.bold,
      this.size = 20,
      this.overflow = TextOverflow.ellipsis});
  Color? color;
  FontWeight fntWight;
  final String text;
  double size;
  TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'rubik',
        fontSize: size,
        color: color,
        fontWeight: fntWight,
      ),
    );
  }
}
