// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pfefinal/home/recipe_of_day_detail.dart';
// import '../widgets/IconAndTextWidget.dart';
// import '../widgets/big_text.dart';

// class ListPlan extends StatefulWidget {
//   const ListPlan({super.key});

//   @override
//   State<ListPlan> createState() => _ListPlanState();
// }

// class _ListPlanState extends State<ListPlan> {
//   PageController pageControllerPlan = PageController(viewportFraction: 0.85);
//   var _currentPageValuePlan = 0.0;
//   double _scaleFactorPlan = 0.8;
//   double _heightPlan = 22;
//   final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner'];

//   @override
//   void initState() {
//     super.initState();
//     pageControllerPlan.addListener(() {
//       setState(() {
//         _currentPageValuePlan = pageControllerPlan.page!;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     pageControllerPlan.dispose();
//     super.dispose();
//   }

// //Function to add recipe to plan
//   Future<List<DocumentSnapshot>> _getMealPlan() async {
//     final user = FirebaseAuth.instance.currentUser;
//     List<DocumentSnapshot> mealPlan = [];

//     if (user != null) {
//       for (String meal in _meals) {
//         DocumentSnapshot mealDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .collection('meal_plan')
//             .doc(meal)
//             .get();

//         if (mealDoc.exists) {
//           mealPlan.add(mealDoc);
//         }
//       }
//     }

//     return mealPlan;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<DocumentSnapshot>>(
//       future: _getMealPlan(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Container(
//             color: Colors.white,
//           );
//         }
//         List<DocumentSnapshot> mealPlan = snapshot.data!;

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 200,
//                 child: PageView.builder(
//                     controller: pageControllerPlan,
//                     itemCount: mealPlan.length,
//                     itemBuilder: (context, position) {
//                       return _buildPageItem(position, mealPlan[position]);
//                     }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPageItem(int index, DocumentSnapshot mealData) {
//     if (!mealData.exists) {
//       return Container(
//         height: 150,
//         margin: const EdgeInsets.only(
//           left: 20,
//           right: 20,
//         ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Colors.white,
//         ),
//       );
//     }
//     Matrix4 matrix = Matrix4.identity();
//     if (index == _currentPageValuePlan.floor()) {
//       var currScale =
//           1 - (_currentPageValuePlan - index) * (1 - _scaleFactorPlan);
//       var currTrans = _heightPlan * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currentPageValuePlan.floor() + 1) {
//       var currScale = _scaleFactorPlan +
//           (_currentPageValuePlan - index + 1) * (1 - _scaleFactorPlan);
//       var currTrans = _heightPlan * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currentPageValuePlan.floor() - 1) {
//       var currScale =
//           1 - (_currentPageValuePlan - index) * (1 - _scaleFactorPlan);
//       var currTrans = _heightPlan * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else {
//       var currScale = 0.8;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, _heightPlan * (1 - _scaleFactorPlan) / 2, 1);
//     }

//     return GestureDetector(
//       onTap: () {
//         if (mealData.exists) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => mealRecipeDetail(recipeDoc: mealData),
//             ),
//           );
//         }
//       },
//       child: Transform(
//         transform: matrix,
//         child: Stack(
//           children: [
//             Container(
//               height: 150,
//               margin: const EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: index.isEven
//                     ? const Color(0xFF69c5df)
//                     : const Color(0xFF9294cc),
//                 image: mealData.exists
//                     ? DecorationImage(
//                         fit: BoxFit.cover,
//                         image: NetworkImage(mealData['image']),
//                       )
//                     : const DecorationImage(
//                         fit: BoxFit.cover,
//                         image: AssetImage('assets/images/recipe1.jpg'),
//                       ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 110,
//                 margin: const EdgeInsets.only(
//                   left: 60,
//                   right: 60,
//                   bottom: 20,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0xFFe8e8e8),
//                       offset: Offset(0, 5),
//                       blurRadius: 10.0,
//                     ),
//                   ],
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.only(
//                     top: 10,
//                     left: 15,
//                     right: 10,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         BigText(
//                           text: _meals[index],
//                           color: const Color.fromARGB(255, 235, 129, 102),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         BigText(
//                           text: mealData.exists
//                               ? mealData['name']
//                               : _meals[index],
//                           color: Colors.black54,
//                         ),
//                         // const SizedBox(
//                         //   height: 10,
//                         // ),
//                         // SmallText(
//                         //   text: mealData.exists
//                         //       ? mealData['chef']
//                         //       : 'No recipe selected',
//                         //   color: Colors.black54,
//                         // ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: mealData.exists
//                               ? [
//                                   IconAndTextWidget(
//                                     icon: Icons.timelapse,
//                                     text: '${mealData['timeToPrepare']} min',
//                                     iconColor: const Color.fromARGB(
//                                         255, 235, 129, 102),
//                                   ),
//                                 ]
//                               : [],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
