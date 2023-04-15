import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/IconAndTextWidget.dart';
import '../widgets/app_icon.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class RecipeDetail extends StatefulWidget {
  final DocumentSnapshot recipeDoc;

  const RecipeDetail({
    super.key,
    required this.recipeDoc,
  });

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];
  final ValueNotifier<String> mealNotifier = ValueNotifier<String>('Breakfast');

  int currentMealIndex = 2;

  Future<void> _saveRecipe() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeData = widget.recipeDoc.data();
      if (recipeData != null) {
        final recipeRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('saved_recipes')
            .doc(widget.recipeDoc.id);

        await recipeRef.set(recipeData as Map<String, dynamic>);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe saved to your collection!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving the recipe'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to save recipes'),
        ),
      );
    }
  }

  void switchLeft() {
    setState(() {
      currentMealIndex = (currentMealIndex - 1 + meals.length) % meals.length;
    });
  }

  void switchRight() {
    setState(() {
      currentMealIndex = (currentMealIndex + 1) % meals.length;
    });
  }

  Future<void> _addToMealPlan(String meal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipeData = widget.recipeDoc.data();
      if (recipeData != null) {
        final mealPlanRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('meal_plan')
            .doc(meals[currentMealIndex]);

        await mealPlanRef.set(recipeData as Map<String, dynamic>);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe added to meal plan!')));
        mealNotifier.value = meal;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error adding recipe to meal plan')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('You need to be logged in to add recipes to meal plan')));
    }
  }

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
                    iconColor: Color.fromARGB(255, 235, 129, 102),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await _saveRecipe();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: const ImageIcon(
                      AssetImage('assets/icons/save.png'),
                      color: Color.fromARGB(255, 235, 129, 102),
                      size: 16,
                    ),
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
      bottomNavigationBar: Container(
        height: 100,

        margin: const EdgeInsets.only(left: 13, right: 13, bottom: 13),
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 30,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // decoration: const BoxDecoration(
        //   color: Color.fromARGB(255, 241, 237, 237),
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20),
        //     topRight: Radius.circular(20),
        //   ),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 129, 102),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: switchLeft,
                        child: const ImageIcon(
                          AssetImage('assets/icons/nav-left.png'),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        meals[currentMealIndex],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: switchRight,
                        child: const ImageIcon(
                          AssetImage('assets/icons/nav-right.png'),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _addToMealPlan(meals[currentMealIndex]);
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 235, 129, 102),
                ),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "add to plan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
