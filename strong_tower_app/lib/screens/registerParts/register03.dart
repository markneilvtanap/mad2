import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:strong_tower_app/screens/registerParts/registerLast.dart';

class RegisterScreen03 extends StatefulWidget {
  RegisterScreen03({
    super.key,
    required this.name,
    required this.username,
    required this.gender,
    required this.province,
    required this.cities,
    required this.barangay,
    required this.medConditions,
    required this.age,
    required this.height,
    required this.goals,
    required this.lifeactivity,
    required this.weight,
  });

  String name, username, gender, province, cities, barangay, medConditions;

  int age;
  double height, weight, goals, lifeactivity;
  @override
  State<RegisterScreen03> createState() => _RegisterScreen03State();
}

class _RegisterScreen03State extends State<RegisterScreen03> {
  var emailController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isNotPassShowable = true;

  double getDailyCalories(String gender, double height, double weight, int age,
      double goals, double lifeactivity) {
    double bmr;
    if (gender == 'Male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);

       double dailyCalories = (bmr * lifeactivity) + (goals);

      return dailyCalories;
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

      double dailyCalories = (bmr * lifeactivity) + (goals);

      return dailyCalories;
    }
  }

//going to next registration
  void nextRegister(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Please wait while checking you email');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text)
          .then((value) async {
        double getCalculation = getDailyCalories(widget.gender, widget.height,
            widget.weight, widget.age, widget.goals, widget.lifeactivity);

        String hold = getCalculation.toStringAsFixed(2);

        double dailyCalories = double.parse(hold);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'username': widget.username,
          'name': widget.name,
          'age': widget.age,
          'gender': widget.gender,
          'height': widget.height,
          'weight': widget.weight,
          'province': widget.province,
          'cities': widget.cities,
          'barangay': widget.barangay,
          'fitnessGoals': widget.goals,
          'lifeActivity': widget.lifeactivity,
          'medConditions': widget.medConditions,
          'dailyCalories': dailyCalories,
          'email': emailController.text,
        }).then((value) {
          Navigator.pop(context);
          QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'Register Success',
                  text:
                      'Wohooo let\'s go you are now ready to start your fitness journey. ')
              .then((value) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => LastRegisterScreen(
                    dailyCalories: dailyCalories.toString(),
                  ),
                ));
          });
        });
      });

      // print(dailyCalories);
      // print(widget.username);
      // print(widget.name);
      // print(widget.age);
      // print(widget.gender);
      // print(widget.height);
      // print(widget.weight);
      // print(widget.province);
      // print(widget.cities);
      // print(widget.barangay);
      // print(widget.goals);
      // print(widget.lifeactivity);
      // print(widget.medConditions);
    } catch (error) {
      Navigator.pop(context);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error Registering',
          text: error.toString());
    }
  }

  void togglePass() {
    isNotPassShowable = !isNotPassShowable;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register Screen',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 255, 17, 0),
          shadowColor: Colors.black,
          elevation: 5,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/images/pic12.jpg',
              fit: BoxFit.cover,
              height: screenHeight,
              width: screenWidth,
            ),
            Container(
              height: screenHeight,
              child: Material(
                elevation: 5,
                color: Color.fromARGB(44, 63, 63, 63),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 211, 211, 211),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Gap(8),
                              Container(
                                width: 50,
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 211, 211, 211),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Gap(8),
                              Container(
                                width: 50,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          Gap(15),
                          Text(
                            'Last Step Registering your Email',
                            style: TextStyle(color: Colors.white, fontSize: 21),
                          ),
                          Gap(15),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Fill this up. Email Address is required.';
                              }

                              if (!EmailValidator.validate(value)) {
                                return 'Invalid Email. PLease put a Email Address.';
                              }

                              return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: const Text(
                                'Email Address',
                                style: TextStyle(color: Colors.white),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          Gap(10),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            obscureText: isNotPassShowable,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Fill this up. Password is required.';
                              }

                              if (value.length < 7) {
                                return 'Password is weak. PLease put a Stronger Password.';
                              }

                              return null;
                            },
                            controller: passController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                suffix: IconButton(
                                    onPressed: togglePass,
                                    icon: Icon(
                                      isNotPassShowable
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ))),
                          ),
                          Gap(10),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            obscureText: isNotPassShowable,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Fill this up. Password is required.';
                              }

                              if (value.length < 7) {
                                return 'Password is weak. PLease put a Stronger Password.';
                              }

                              if (value != passController.text) {
                                return 'Password are not the same.';
                              }

                              return null;
                            },
                            controller: confirmPassController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: const Text('Confirm Password',
                                  style: TextStyle(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          Gap(10),
                          ElevatedButton(
                              onPressed: () {
                                nextRegister(context);
                              },
                              child: const Text('Next'))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
