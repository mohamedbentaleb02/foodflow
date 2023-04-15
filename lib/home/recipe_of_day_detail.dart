import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/IconAndTextWidget.dart';
import '../widgets/app_icon.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class mealRecipeDetail extends StatefulWidget {
  final DocumentSnapshot recipeDoc;
  const mealRecipeDetail({super.key, required this.recipeDoc});

  @override
  State<mealRecipeDetail> createState() => _mealRecipeDetailState();
}

class _mealRecipeDetailState extends State<mealRecipeDetail> {
  int currentMealIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              width: 100,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.recipeDoc['image']),
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const AppIcon(
                    icon: Icons.arrow_back_ios,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    iconColor:  Color.fromARGB(255, 235, 129, 102),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 300,
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 300,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    text: widget.recipeDoc['name'],
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/images/chef.jpg'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SmallText(
                            text: widget.recipeDoc['chef'],
                          ),
                        ],
                      ),
                      IconAndTextWidget(
                        icon: Icons.timelapse,
                        text: '${widget.recipeDoc['timeToPrepare']} min',
                        iconColor: const Color.fromARGB(255, 235, 129, 102),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SmallText(
                    text: widget.recipeDoc['description'],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
