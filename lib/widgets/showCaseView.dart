import 'package:flutter/cupertino.dart';

class showCaseView extends StatelessWidget {
  const showCaseView(
      {super.key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder()});
  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  @override
  Widget build(BuildContext context) {
    return showCaseView(
        description: description,
        globalKey: globalKey,
        title: title,
        shapeBorder: shapeBorder,
        child: child);
  }
}
