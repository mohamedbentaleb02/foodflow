import 'package:flutter/material.dart';
import 'package:pfefinal/widgets/app_icon.dart';
import 'package:pfefinal/widgets/big_text.dart';
import 'package:pfefinal/widgets/small_text.dart';

class accountWidget extends StatelessWidget {
  AppIcon appicon;
  Text txt;
  accountWidget({super.key, required this.appicon, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 320,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 235, 129, 102),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: const Offset(0, 5),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        children: [
          appicon,
          Expanded(
            child: txt,
          ),
        ],
      ),
    );
  }
}
