import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfefinal/home/home_page.dart';
import 'package:pfefinal/home/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  //function to login with email and password
  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passController.text);

      // Signed in successfully, navigate to the next screen.
      Get.to(
          const HomePage()); // Replace 'NextScreen' with the actual next screen in your app.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else {
        Get.snackbar('Error', 'An error occurred during sign-in: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // Handle error, show a message to the user.
    }
  }

  _showWorkerDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Reset Password!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 235, 129, 102),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const ClipRRect(
                  // add the image
                  child: Image(
                    image: AssetImage('assets/icons/FoodFlow.png'),
                    height: 110,
                    width: 140,
                  ),
                ),
                const SizedBox(height: 45),

                // Email TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 129, 102),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(17)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                          controller: emailController,
                          style: GoogleFonts.spaceMono(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: GoogleFonts.spaceMono(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Reset password button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 20),
                  child: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 167, 150),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Send Request',
                          style: GoogleFonts.spaceMono(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                //email, password textField and recovery password here
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      emailTextField(size),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      passwordTextField(size),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 200,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                //resetPassword(emailController.text);
                                _showWorkerDetailsDialog();
                              },
                              child: const Text(
                                'Forget Password?',
                                style: TextStyle(
                                  fontFamily: 'rubik',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //sign in button here
                Expanded(flex: 1, child: signInButton(size)),
                //footer content
                //don't have account text,social logo and sign up text here
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
              width: 3,
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
                      color: Color.fromARGB(181, 255, 255, 255),
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
                    color: Color.fromARGB(181, 255, 255, 255),
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
        _signInWithEmailAndPassword();
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
          'Login',
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
      children: const <Widget>[
        Expanded(
            flex: 2,
            child: Divider(
              color: Color(0xFF969AA8),
            )),
        Expanded(
          flex: 3,
          child: Text(
            'Sign in with ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'rubik',
              fontSize: 12.0,
              color: Color(0xFF969AA8),
              fontWeight: FontWeight.w700,
              height: 1.67,
            ),
          ),
        ),
        Expanded(
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
                  child: Image.asset('assets/icons/g.png'),
                ),
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
                'Do not have account ? ',
                style: TextStyle(
                  fontFamily: 'rubik',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const Signup());
                },
                child: const Text(
                  'Sign up ',
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
