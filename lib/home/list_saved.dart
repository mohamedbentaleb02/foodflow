import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfefinal/widgets/big_text.dart';
import '../widgets/IconAndTextWidget.dart';

class ListSaved extends StatefulWidget {
  const ListSaved({super.key});

  @override
  State<ListSaved> createState() => _ListSavedState();
}

class _ListSavedState extends State<ListSaved> {
  // Fetch saved recipes for the current user
  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedRecipes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<void> _deleteRecipe(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_recipes')
          .doc(recipeId)
          .delete();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Recipe deleted!')));

      // Refresh the list of saved recipes
      setState(() {
        getSavedRecipes();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You need to be logged in to delete recipes')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Saved Recipes',
          style: TextStyle(fontFamily: 'rubik'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 129, 102),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            bottom: 0,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: false,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getSavedRecipes(),
                builder: (context, snapshot) {
                  // if (snapshot.hasError) {
                  //   return Center(child: Text('Error: ${snapshot.error}'));
                  // }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final recipes = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (_, index) {
                      final recipe = recipes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 13),
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
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
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
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BigText(
                                      text: recipe['name'],
                                      color: Colors.black45,
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
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          IconAndTextWidget(
                                            icon: Icons.timelapse,
                                            text:
                                                '${recipe['timeToPrepare']} min',
                                            iconColor: const Color.fromARGB(
                                                255, 235, 129, 102),
                                          ),
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _deleteRecipe(recipes[index].id);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 235, 129, 102),
                                            ),
                                          )
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
