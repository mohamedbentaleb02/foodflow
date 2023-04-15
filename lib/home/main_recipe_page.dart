import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfefinal/home/list_saved.dart';
import 'package:pfefinal/home/planlistview.dart';
import 'package:pfefinal/home/recipe_page_body.dart';

import '../widgets/IconAndTextWidget.dart';
import '../widgets/big_text.dart';
import '../widgets/showCaseView.dart';

class MainRecipePage extends StatefulWidget {
  const MainRecipePage({super.key});

  @override
  State<MainRecipePage> createState() => _MainRecipePageState();
}

class _MainRecipePageState extends State<MainRecipePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  Stream<QuerySnapshot> recipesStream =
      FirebaseFirestore.instance.collection('recipe').snapshots();
  void _showSearchResults(BuildContext context, QuerySnapshot snapshot) {
    // Filter the recipes based on the search text
    List<QueryDocumentSnapshot> filteredRecipes = snapshot.docs
        .where((doc) => doc['name']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 96.0, left: 21, right: 21, bottom: 60),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (_, index) {
                  final recipe =
                      filteredRecipes[index].data() as Map<String, dynamic>;
                  return Container(
                    margin:
                        const EdgeInsets.only(left: 13, bottom: 13, right: 13),
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
                    height: 100,
                    width: 200,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(recipe['image']),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(
                                  text: recipe['name'],
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconAndTextWidget(
                                        icon: Icons.timelapse,
                                        text: '${recipe['timeToPrepare']} min',
                                        iconColor: const Color.fromARGB(
                                            255, 235, 129, 102),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 15,
                top: 45,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      width: 320,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 235, 129, 102),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                fontFamily: 'rubik',
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search for recipe ...',
                                hintStyle: TextStyle(
                                  fontFamily: 'rubik',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: const ImageIcon(
                                AssetImage('assets/icons/search.png')),
                            onPressed: () {
                              setState(() {
                                searchText = _searchController.text;
                              });
                              recipesStream.listen((snapshot) {
                                _showSearchResults(context, snapshot);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const RecipePageBody(),
          ],
        ),
      ),
    );
  }
}
