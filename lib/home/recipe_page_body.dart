import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pfefinal/home/list_saved.dart';
import 'package:pfefinal/home/planlistview.dart';
import 'package:pfefinal/home/recipe_detail.dart';
import 'package:pfefinal/widgets/IconAndTextWidget.dart';
import 'package:pfefinal/widgets/big_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/small_text.dart';
import 'all_recipes.dart';

class RecipePageBody extends StatefulWidget {
  const RecipePageBody({super.key});

  @override
  State<RecipePageBody> createState() => _RecipePageBodyState();
}

class _RecipePageBodyState extends State<RecipePageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = 22;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText(
                text: "All recipes",
                color: Colors.black54,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const AllRecipes());
                },
                child: const Text(
                  'see all',
                  style: TextStyle(
                    color: Color.fromARGB(255, 235, 129, 102),
                    fontFamily: 'rubik',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: SizedBox(
            height: 220,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('recipe').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  return snapshot.data == null
                      ? const Center(child: CircularProgressIndicator())
                      : PageView.builder(
                          controller: pageController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, position) {
                            return _buildPageItem(
                                position, snapshot.data!.docs[position]);
                          },
                        );
                }),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              BigText(
                text: "Today's Plan",
                color: Colors.black54,
              )
            ],
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        const planList(),
      ],
    );
  }

  Widget _buildPageItem(int index, DocumentSnapshot doc) {
    Map<String, dynamic>? recipe = doc.data() as Map<String, dynamic>?;
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipeDoc: doc),
          ),
        );
      },
      child: Transform(
        transform: matrix,
        child: Stack(
          children: [
            Container(
              height: 165,
              margin: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven
                    ? const Color(0xFF69c5df)
                    : const Color(0xFF9294cc),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    recipe!['image'],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 99,
                margin: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      BigText(
                        text: recipe['name'] ?? 'N/A',
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        height: 15,
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
                                text: recipe['chef'],
                              ),
                            ],
                          ),
                          IconAndTextWidget(
                            icon: Icons.timelapse,
                            text: '${recipe['timeToPrepare']} min',
                            iconColor: const Color.fromARGB(255, 235, 129, 102),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
