import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class createRecipe extends StatefulWidget {
  const createRecipe({super.key});

  @override
  State<createRecipe> createState() => _createRecipeState();
}

class _createRecipeState extends State<createRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create recipe ',
          style: TextStyle(fontFamily: 'rubik'),
        ),
        backgroundColor: const Color.fromARGB(255, 235, 129, 102),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 330,
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 235, 129, 102),
                            width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            radius: 50,
                            // backgroundImage: _imageUrl.startsWith('http')
                            //     ? NetworkImage(_imageUrl)
                            //         as ImageProvider<Object>
                            //     : AssetImage(_imageUrl),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 330,
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 235, 129, 102),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.food_bank,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  fontFamily: 'rubik',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    hintText: 'Enter the recipe name',
                                    hintStyle: TextStyle(
                                      fontFamily: 'rubik',
                                      fontSize: 16.0,
                                      color: Color.fromARGB(181, 255, 255, 255),
                                      height: 1.0,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 235, 129, 102),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 235, 129, 102),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.timelapse,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  fontFamily: 'rubik',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    hintText: 'Enter the recipe time',
                                    hintStyle: TextStyle(
                                      fontFamily: 'rubik',
                                      fontSize: 16.0,
                                      color: Color.fromARGB(181, 255, 255, 255),
                                      height: 1.0,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 235, 129, 102),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 235, 129, 102),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: SizedBox(
                                height: 220,
                                child: TextField(
                                  style: TextStyle(
                                    fontFamily: 'rubik',
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  minLines: 1,
                                  textAlignVertical: TextAlignVertical.top,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      hintText: 'Recipe description ...',
                                      hintStyle: TextStyle(
                                        fontFamily: 'rubik',
                                        fontSize: 16.0,
                                        color:
                                            Color.fromARGB(181, 255, 255, 255),
                                        height: 1.0,
                                      ),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 235, 129, 102),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color.fromARGB(255, 235, 129, 102),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 235, 129, 102)
                            .withOpacity(0.2),
                        offset: const Offset(0, 15.0),
                        blurRadius: 60.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      fontFamily: 'rubik',
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
