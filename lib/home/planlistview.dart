import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pfefinal/home/recipe_of_day_detail.dart';

import '../widgets/IconAndTextWidget.dart';
import '../widgets/big_text.dart';

class planList extends StatefulWidget {
  const planList({super.key});

  @override
  State<planList> createState() => _planListState();
}

class _planListState extends State<planList> {
  var _currentPageValuePlan = 0.0;
  double _scaleFactorPlan = 0.8;
  double _heightPlan = 22;
  final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  void initState() {
    super.initState();
  }

//Function to add recipe to plan
  Future<List<DocumentSnapshot>> _getMealPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    List<DocumentSnapshot> mealPlan = [];

    if (user != null) {
      for (String meal in _meals) {
        DocumentSnapshot mealDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('meal_plan')
            .doc(meal)
            .get();

        if (mealDoc.exists) {
          mealPlan.add(mealDoc);
        }
      }
    }

    return mealPlan;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _getMealPlan(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            color: Colors.white,
          );
        }
        List<DocumentSnapshot> mealPlan = snapshot.data!;

        return Container(
          height: 313,
          child: ListView.builder(
              itemCount: mealPlan.length,
              itemBuilder: (context, position) {
                return _buildPageItem(position, mealPlan[position]);
              }),
        );
      },
    );
  }

  Widget _buildPageItem(int index, DocumentSnapshot mealData) {
    if (!mealData.exists) {
      return Container(
        //height: 10,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (mealData.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => mealRecipeDetail(recipeDoc: mealData),
            ),
          );
        }
      },
      child: Container(
        height: 88,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(mealData['image']),
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: _meals[index],
                      color: const Color.fromARGB(255, 235, 129, 102),
                    ),
                    const ImageIcon(
                      AssetImage('assets/icons/saved.png'),
                      color: Color.fromARGB(255, 235, 129, 102),
                      size: 25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: mealData.exists ? mealData['name'] : _meals[index],
                      color: Colors.black54,
                    ),
                    IconAndTextWidget(
                      icon: Icons.timelapse,
                      text: '${mealData['timeToPrepare']} min',
                      iconColor: const Color.fromARGB(255, 235, 129, 102),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
