import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:strong_tower_app/screens/user/calo_track.dart/add_food.dart';
import 'package:strong_tower_app/screens/user/calo_track.dart/diary.dart';
import 'dart:math';
import 'package:strong_tower_app/screens/user/calo_track.dart/search_food.dart';

class CaloritTrackScreen extends StatefulWidget {
  const CaloritTrackScreen({super.key});

  @override
  State<CaloritTrackScreen> createState() => _CaloritTrackScreenState();
}

class _CaloritTrackScreenState extends State<CaloritTrackScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrivedailyCaloriesIntake();
    getAllCaloriesIntake();
    // getBreakfastTotal();
    // getLunchTotal();
  }

  final curr_id = FirebaseAuth.instance.currentUser!.uid;

  List<Color> colorList = [
    Colors.red,
    Colors.grey,
  ];

  String _month = DateFormat('MMMM').format(DateTime.now());
  // Map<String, double> trackCalorie = {
  //   'Calorie Take': 200,
  //   'Calorie To Take': 0,
  // };
  double dailyCaloriesIntake = 1000;
  double todayCalorieIntake = 1000;
  double breakfastTotal = 0, lunchTotal = 0, dinnerTotal = 0, snackTotal = 0;

  Future<void> retrivedailyCaloriesIntake() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(curr_id).get();

    dailyCaloriesIntake = snap['dailyCalories'];

    setState(() {});
  }

  void change(DateTime? month) {
    _month = DateFormat('MMMM').format(month!);
    print(_month);
    setState(() {});
  }

  Future<void> getBreakfastTotal() async {
    QuerySnapshot breakfast = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Breakfast')
        .get();

    try {
      final dataBreakfast = breakfast.docs;

      dataBreakfast.forEach((element) {
        print(element['totalCalories']);

        double getCalorie = element['totalCalories'];
        breakfastTotal += getCalorie;
      });
      setState(() {});
    } catch (e) {
      breakfastTotal = 0;
    }
  }

  Future<void> getLunchTotal() async {
    QuerySnapshot lunch = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Lunch')
        .get();

    try {
      final dataLunch = lunch.docs;

      dataLunch.forEach((element) {
        double getCalorie = element['totalCalories'];
        lunchTotal += getCalorie;
        print('lunch total $lunchTotal');
      });

      setState(() {});
    } catch (e) {
      lunchTotal = 0;
    }
  }

  Future<void> getAllCaloriesIntake() async {
    QuerySnapshot breakfast = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Breakfast')
        .get();

    try {
      final dataBreakfast = breakfast.docs;

      dataBreakfast.forEach((element) {
        double getCalorie = element['totalCalories'];
        breakfastTotal += getCalorie;
      });

      setState(() {});
    } catch (e) {
      breakfastTotal = 0;
    }

    QuerySnapshot lunch = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Lunch')
        .get();

    try {
      final dataLunch = lunch.docs;

      dataLunch.forEach((element) {
        double getCalorie = element['totalCalories'];
        lunchTotal += getCalorie;
        print('lunch total $lunchTotal');
      });

      setState(() {});
    } catch (e) {
      lunchTotal = 0;
    }

    QuerySnapshot dinner = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Dinner')
        .get();

    try {
      final dataDinner = dinner.docs;

      dataDinner.forEach((element) {
        double getCalorie = element['totalCalories'];
        dinnerTotal += getCalorie;
      });

      setState(() {});
    } catch (e) {
      dinnerTotal = 0;
    }

    QuerySnapshot snack = await FirebaseFirestore.instance
        .collection('users')
        .doc(curr_id)
        .collection('CalorieTrack')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .collection('Snack')
        .get();

    try {
      final dataSnack = snack.docs;

      dataSnack.forEach((element) {
        double getCalorie = element['totalCalories'];
        snackTotal += getCalorie;
      });

      setState(() {});
    } catch (e) {
      snackTotal = 0;
    }
    double getTotal = breakfastTotal + lunchTotal + dinnerTotal + snackTotal;

    String toConvert = getTotal.toStringAsFixed(2);

    todayCalorieIntake = double.parse(toConvert);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(curr_id)
          .collection('CalorieTrack')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .update({
        'date': Timestamp.now(),
        'DayCalorieGoals': dailyCaloriesIntake,
        'DayCalorieIntake': todayCalorieIntake,
      });
    } catch (e) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(curr_id)
          .collection('CalorieTrack')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
        'date': Timestamp.now(),
        'DayCalorieGoals': dailyCaloriesIntake,
        'DayCalorieIntake': todayCalorieIntake,
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final overIntake = todayCalorieIntake > dailyCaloriesIntake;
    double remainingCalories =
        overIntake ? 0 : dailyCaloriesIntake - todayCalorieIntake;
    final intake = overIntake ? dailyCaloriesIntake : todayCalorieIntake;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "Track your Calorie",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchFoodScreen(
                      myFunction: getAllCaloriesIntake,
                    ),
                  ));
                },
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(241, 255, 0, 0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 50,
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: intake,
                                  title: overIntake ? 'Over Intake' : 'Intake',
                                  radius: 50,
                                  titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: overIntake
                                      ? Color.fromARGB(255, 240, 66, 54)
                                      : Colors.grey,
                                  value: overIntake
                                      ? (todayCalorieIntake -
                                              dailyCaloriesIntake)
                                          .toDouble()
                                      : remainingCalories.toDouble(),
                                  title: overIntake ? 'Over' : 'Remaining',
                                  radius: 50,
                                  titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Gap(50),
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Today Calorie Goals',
                              style: TextStyle(
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '$dailyCaloriesIntake',
                              style: TextStyle(
                                  fontSize: screenWidth / 17,
                                  color: Colors.white),
                            ),
                            Gap(30),
                            Text(
                              'Today Calorie Intake',
                              style: TextStyle(
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '$todayCalorieIntake',
                              style: TextStyle(
                                  fontSize: screenWidth / 17,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              Gap(10),
              Gap(15),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => DiaryFoodScreen(
                        goal: dailyCaloriesIntake,
                        intake: todayCalorieIntake,
                      ),
                    ));
                  },
                  child: const Text('food Diary')),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          _month,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: () async {
                            final month = await showMonthYearPicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(3012));
                            change(month);
                          },
                          child: Text(
                            "Pick a Month",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight - screenHeight / 5,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(curr_id)
                          .collection('CalorieTrack')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = snapshot.data!.docs;

                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return DateFormat('MMMM').format(
                                          data[index]['date'].toDate()) ==
                                      _month
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, right: 10, left: 10),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 10,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                DateFormat(
                                                  'EE\n dd',
                                                ).format(data[index]['date']
                                                    .toDate()),
                                                style: TextStyle(
                                                  fontSize: screenWidth / 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Calorie Goals",
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${data[index]['DayCalorieGoals']}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                          Expanded(
                                              child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Calorie Intake",
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${data[index]['DayCalorieIntake']}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
