import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pfefinal/home/createRecipe.dart';
import 'package:pfefinal/home/login.dart';
import 'package:pfefinal/widgets/app_icon.dart';
import 'package:pfefinal/widgets/big_text.dart';
import '../widgets/account_widget.dart';
import '../widgets/small_text.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profil extends StatefulWidget {
  Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  User? _user;
  String _password = '';
  String _name = '';
  String _email = '';
  String _imageUrl = 'assets/images/chef1.jpg';
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

// Function to fetch the user's data from Firestore
  Future<void> _fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_user?.uid)
        .get();
    setState(() {
      _name = userDoc.get('name');
      _email = userDoc.get('email');
      _password = userDoc.get('password');
      _imageUrl = userDoc.get('image');
    });
  }

  // Function to sign out the user
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.to(const Login());
  }

  // Function to change the profile picture
  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 800);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('profilePictures/${_user?.uid}');
      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user?.uid)
            .update({'image': imageUrl});
        setState(() {
          _imageUrl = imageUrl;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                          onTap: _changeProfilePicture,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageUrl.startsWith('http')
                                ? NetworkImage(_imageUrl)
                                    as ImageProvider<Object>
                                : AssetImage(_imageUrl),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontFamily: 'rubik',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallText(
                        text:
                            'to be chef you should send a requist to our team then wait 24H so we can answer your requist'),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 235, 129, 102),
                      ),
                      onPressed: () {
                        Get.to(const createRecipe());
                      },
                      child: const Text(
                        'Be chef',
                        style: TextStyle(
                          fontFamily: 'rubik',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 330,
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    accountWidget(
                      appicon: const AppIcon(icon: Icons.email),
                      txt: Text(
                        _email,
                        style: const TextStyle(
                            fontFamily: 'rubik', color: Colors.white),
                      ),
                    ),
                    //password
                    const SizedBox(
                      height: 20,
                    ),
                    accountWidget(
                      appicon: const AppIcon(icon: Icons.lock_outline_rounded),
                      txt: Text(
                        _password,
                        style: const TextStyle(
                            fontFamily: 'rubik', color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 235, 129, 102),
                      ),
                      onPressed: _signOut,
                      child: const Text(
                        'Sign out',
                        style: TextStyle(
                          fontFamily: 'rubik',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
