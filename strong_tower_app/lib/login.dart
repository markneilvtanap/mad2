import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quickalert/quickalert.dart';
import 'package:strong_tower_app/default.dart';
import 'package:strong_tower_app/screens/registerParts/register01.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passController = TextEditingController();

  bool isVisiblePass = true;

  // ShowPassword
  void showPassword() {
    isVisiblePass = !isVisiblePass;
    setState(() {});
  }

  // Logging in
  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Logging In',
        text: 'Trying to Login Please Wait',
      );

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      )
          .then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DefaultScreen(),
          ),
        );
      });
    } catch (error) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error Logging In',
        text: error.toString(),
      );
    }
  }

  // Registering
  void register() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RegisterScreen01(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/pic4.jpg',
            fit: BoxFit.cover,
            height: screenHeight,
            width: screenWidth,
          ),
          Material(
            elevation: 4,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: screenWidth / 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Gap(10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Fill this up. Email Address is required.';
                        }

                        if (!EmailValidator.validate(value)) {
                          return 'Invalid Email. Please put an Email Address.';
                        }

                        return null;
                      },
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    Gap(15),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Fill this up. Password is required.';
                        }

                        if (value.length < 7) {
                          return 'Password is weak. Please put a Stronger Password.';
                        }

                        return null;
                      },
                      obscureText: isVisiblePass,
                      controller: passController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: showPassword,
                          icon: Icon(
                            isVisiblePass
                                ? Ionicons.eye_off_outline
                                : Ionicons.eye_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Gap(12),
                    ElevatedButton(
                      onPressed: login,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Change button color to red
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Doesn\'t have an Account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: register,
                          child: Text(
                            'Register here',
                            style: TextStyle(color: Colors.blue),
                          ),
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
    );
  }
}
