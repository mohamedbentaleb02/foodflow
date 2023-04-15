import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfefinal/widgets/big_text.dart';
import 'package:pfefinal/widgets/small_text.dart';
import '../widgets/IconAndTextWidget.dart';

class AllRecipes extends StatefulWidget {
  const AllRecipes({super.key});

  @override
  State<AllRecipes> createState() => _AllRecipesState();
}

class _AllRecipesState extends State<AllRecipes> {
  // Fetch saved recipes for the current user
  Stream<QuerySnapshot<Map<String, dynamic>>> getallRecipes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('recipe').snapshots();
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'All Recipes',
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
                stream: getallRecipes(),
                builder: (context, snapshot) {
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
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 10,
                                                backgroundImage: AssetImage(
                                                    'assets/images/chef.jpg'),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SmallText(
                                                text: recipe['chef'],
                                              ),
                                            ],
                                          ),
                                          IconAndTextWidget(
                                            icon: Icons.timelapse,
                                            text:
                                                '${recipe['timeToPrepare']} min',
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
