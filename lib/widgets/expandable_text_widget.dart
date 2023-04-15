import 'package:flutter/cupertino.dart';

class ExpandabaleTextWidget extends StatefulWidget {
  final String text;
  const ExpandabaleTextWidget({super.key, required this.text});

  @override
  State<ExpandabaleTextWidget> createState() => _ExpandabaleTextWidgetState();
}

class _ExpandabaleTextWidgetState extends State<ExpandabaleTextWidget> {
  late String firstHalf;
  late String secendHalf;
  bool hiddenText = true;
  double textHeight = 15;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
