import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:strong_tower_app/login.dart';

class LastRegisterScreen extends StatelessWidget {
  LastRegisterScreen({super.key, required this.dailyCalories});

  String dailyCalories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/strong_tower_image.png',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Here your Daily calorie Goals!',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Gap(20),
                        Text(
                          dailyCalories,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 20, bottom: 20),
                  child: Text(
                    'Welcome to Strong Tower Gym! Remember, every rep, every step, and every drop of sweat brings you closer to your goals. You have the strength within you to conquer any challenge. Stay focused, stay determined, and let\'s crush it together',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    child: const Text(
                      'Let\'s go ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ));
  }
}
