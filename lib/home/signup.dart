import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefinal/home/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void _handleSignUpButtonPress() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      // Create user profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        'password': passController.text,
        // Add additional fields as necessary
      });
      // User successfully signed up
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      logo(size.height / 4, size.height / 4),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        nameTextField(size),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        emailTextField(size),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        passwordTextField(size),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(flex: 1, child: signInButton(size)),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildNoAccountText(),
                      SizedBox(
                        height: size.height * 0.03,
                      ),

                      //here social logo and sign up text
                      buildFooter(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/images/chefs.png',
      height: height_,
      width: width_,
    );
  }

  Widget nameTextField(Size size) {
    return Container(
      height: size.height / 13,
      width: size.width / 1.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 235, 129, 102),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontFamily: 'rubik',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                maxLines: 1,
                keyboardType: TextInputType.name,
                //cursorColor: const Color.fromARGB(255, 77, 122, 80),
                decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(
                      fontFamily: 'rubik',
                      fontSize: 16.0,
                      color: Colors.white,
                      height: 1.0,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 235, 129, 102),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: emailController.text.isEmpty
                            ? Colors.transparent
                            : const Color.fromARGB(255, 235, 129, 102),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: emailController.text.isEmpty
                            ? Colors.transparent
                            : const Color.fromARGB(255, 235, 129, 102),
                      ),
                    ),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Container(
      height: size.height / 13,
      width: size.width / 1.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 235, 129, 102),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(
              Icons.email,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: emailController,
                style: const TextStyle(
                  fontFamily: 'rubik',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      fontFamily: 'rubik',
                      fontSize: 16.0,
                      color: Colors.white,
                      height: 1.0,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 235, 129, 102),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: emailController.text.isEmpty
                            ? Colors.transparent
                            : const Color.fromARGB(255, 235, 129, 102),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: emailController.text.isEmpty
                            ? Colors.transparent
                            : const Color.fromARGB(255, 235, 129, 102),
                      ),
                    ),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      height: size.height / 13,
      width: size.width / 1.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 235, 129, 102),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: passController,
                style: const TextStyle(
                  fontFamily: 'rubik',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    fontFamily: 'rubik',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            passController.text.isEmpty
                ? const Center()
                : Container(
                    height: 30,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 129, 102),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: () {
        _handleSignUpButtonPress();
        //Get.to(const HomePage());
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        width: size.width / 2.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color.fromARGB(255, 235, 129, 102),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 235, 129, 102).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: const Text(
          'Sign up',
          style: TextStyle(
            fontFamily: 'rubik',
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildNoAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(
            flex: 2,
            child: Divider(
              color: Color(0xFF969AA8),
            )),
        Expanded(
          flex: 3,
          child: Text(
            'Or Sign up with ',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
              fontWeight: FontWeight.w500,
              height: 1.67,
            ),
          ),
        ),
        const Expanded(
            flex: 2,
            child: Divider(
              color: Color(0xFF969AA8),
            )),
      ],
    );
  }

  Widget buildFooter(Size size) {
    return Center(
      child: Column(
        children: <Widget>[
          //social icon here
          SizedBox(
            width: size.width * 0.6,
            height: 44.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //facebook logo here
                Container(
                  alignment: Alignment.center,
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: const Color.fromRGBO(246, 246, 246, 1)),
                  child: Image.asset('assets/icons/f.png'),
                ),
                const SizedBox(width: 5),

                //google logo here
                Container(
                    alignment: Alignment.center,
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: const Color.fromRGBO(246, 246, 246, 1)),
                    child: Image.asset('assets/icons/g.png')),
                const SizedBox(width: 16),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have account ? ',
                style: TextStyle(
                  fontFamily: 'rubik',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const Login());
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'rubik',
                    fontSize: 12.0,
                    color: Color.fromARGB(255, 235, 129, 102),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
