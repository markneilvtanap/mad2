import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:quickalert/quickalert.dart';
import 'package:strong_tower_app/login.dart';
import 'package:strong_tower_app/screens/registerParts/register03.dart';

class RegisterScreen02 extends StatelessWidget {
  RegisterScreen02(
      {super.key,
      required this.name,
      required this.age,
      required this.gender,
      required this.height,
      required this.weight,
      required this.province,
      required this.cities,
      required this.barangay});

//previous screen data stored in variable
  String name, gender, province, cities, barangay;
  int age;
  double height, weight;

  var conditionsController = TextEditingController();
  var userNameController = TextEditingController();
  var goalsController = TextEditingController();
  var activityController = TextEditingController();
  late String _medConditions;
  double edgePadding = 14.0;
//variable for dropdown selection

  late double _selectedGoals;
  Map<String, String> _goals = {
    'weight loss': '-500.0',
    'weight gain': '500.0',
    'maintain Weight': '0',
  };

  Map<String, String> _lifeActivity = {
    'Sedentary (little or no exercise)': '1.2',
    'Lightly active (light exercise/sports 1-3 days/week)': '1.375',
    'Moderately active (moderate exercise/sports 3-5 days/week)': '1.55',
    'Very active (hard exercise/sports 6-7 days a week)': '1.725',
    'Extra active (very hard exercise/sports & physical job or 2x training)':
        '1.9',
  };
  late double _selectedlifeActivity;

  final formKey = GlobalKey<FormState>();
// function for registering
  void register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (conditionsController.text.isNotEmpty) {
      _medConditions = conditionsController.text;
    }
    if (conditionsController.text.isEmpty ||
        conditionsController.text == null) {
      _medConditions = "none";
    }

    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => RegisterScreen03(
        age: age,
        barangay: barangay,
        cities: cities,
        gender: gender,
        goals: _selectedGoals,
        height: height,
        lifeactivity: _selectedlifeActivity,
        medConditions: _medConditions,
        name: name,
        username: userNameController.text,
        province: province,
        weight: weight,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - edgePadding * 2;
    final screenWidth2 = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Register Screen',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 255, 17, 0),
          shadowColor: Colors.black,
          elevation: 5,
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/pic11.jpg',
              fit: BoxFit.cover,
              height: screenHeight,
              width: screenWidth2,
            ),
            Container(
              height: screenHeight,
              child: Material(
                elevation: 5,
                color: Color.fromARGB(44, 63, 63, 63),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(
                                  width:
                                      8), // Add some space between containers

                              Container(
                                width: 50, // Adjust as needed
                                height: 12, // Adjust as needed
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                      8), // Add border radius
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between containers
                              Container(
                                width: 50, // Adjust as needed
                                height: 6, // Adjust as needed
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 211, 211, 211),
                                  borderRadius: BorderRadius.circular(
                                      8), // Add border radius
                                ),
                              ),
                            ],
                          ),
                          Gap(15),
                          Text(
                            'Fitness Question',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                          Gap(15),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Fill this up. Username is required.';
                              }

                              return null;
                            },
                            controller: userNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                          Gap(15),
                          Card(
                            elevation: 5,
                            child: DropdownMenu(
                              width: screenWidth,
                              controller: goalsController,
                              label: const Text('Select your Fitness Goals'),
                              //   width: screenWidth,
                              dropdownMenuEntries: _goals.entries.map((item) {
                                return DropdownMenuEntry(
                                    value: item.value, label: item.key);
                              }).toList(),
                              onSelected: (value) {
                                _selectedGoals = double.parse(value.toString());
                                print(_selectedGoals);
                              },
                            ),
                          ),
                          Gap(15),
                          Card(
                            elevation: 5,
                            child: DropdownMenu(
                              width: screenWidth,
                              controller: activityController,
                              label: const Text('Select your Activity Level'),
                              //   width: screenWidth,
                              dropdownMenuEntries:
                                  _lifeActivity.entries.map((item) {
                                return DropdownMenuEntry(
                                    value: item.value, label: item.key);
                              }).toList(),
                              onSelected: (value) {
                                _selectedlifeActivity =
                                    double.parse(value.toString());

                                print(_selectedlifeActivity);
                              },
                            ),
                          ),
                          Gap(15),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            maxLines: 3,
                            controller: conditionsController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Medical Conditions?',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                          Gap(15),
                          ElevatedButton(
                              onPressed: () {
                                register(context);
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
