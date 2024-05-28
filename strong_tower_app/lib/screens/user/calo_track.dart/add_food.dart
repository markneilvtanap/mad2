import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:pie_chart/pie_chart.dart';

class AddCalorieScreen extends StatefulWidget {
  AddCalorieScreen({
    super.key,
    required this.foodId,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.serSize,
    required this.myFunction,
  });

  final Future<void> Function() myFunction;
  String foodId, serSize;
  double protein, carbohydrates, fat, calories;

  @override
  State<AddCalorieScreen> createState() => _AddCalorieScreenState();
}

class _AddCalorieScreenState extends State<AddCalorieScreen> {
  Map<String, double> foodIemStat = {};
  var nServingsController = TextEditingController();
  late int nServings = 1;
  final curr_id = FirebaseAuth.instance.currentUser!.uid;
  final formKey = GlobalKey<FormState>();
  List<String> meal = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  List<Color> colorList = [
    Colors.red,
    Color.fromARGB(255, 21, 0, 255),
    Colors.yellow,
  ];

  String dropdownValue = 'Option 1';
  double edgePadding = 14.0;
  double oldValue = 0;
  String selectedMeal = '';

  void Add() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      if (selectedMeal == 'Breakfast') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(curr_id)
            .collection('CalorieTrack')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .collection('Breakfast')
            .add({
          'foodName': widget.foodId,
          'Meal': selectedMeal,
          'Protein': proteinCalories(widget.protein, nServings, oldValue),
          'Carbohydrates':
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
          'Fats': fatCalories(widget.fat, nServings, oldValue),
          'totalCalories': totalCalories(
              proteinCalories(widget.protein, nServings, oldValue),
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
              fatCalories(widget.fat, nServings, oldValue),
              oldValue)
        }).then((value) async {
          final result = await widget.myFunction();
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Food logged'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }

      if (selectedMeal == 'Lunch') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(curr_id)
            .collection('CalorieTrack')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .collection('Lunch')
            .add({
          'foodName': widget.foodId,
          'Meal': selectedMeal,
          'Protein': proteinCalories(widget.protein, nServings, oldValue),
          'Carbohydrates':
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
          'Fats': fatCalories(widget.fat, nServings, oldValue),
          'totalCalories': totalCalories(
              proteinCalories(widget.protein, nServings, oldValue),
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
              fatCalories(widget.fat, nServings, oldValue),
              oldValue)
        }).then((value) async {
          final result = await widget.myFunction();
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Food logged'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        ;
      }

      if (selectedMeal == 'Dinner') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(curr_id)
            .collection('CalorieTrack')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .collection('Dinner')
            .add({
          'foodName': widget.foodId,
          'Meal': selectedMeal,
          'Protein': proteinCalories(widget.protein, nServings, oldValue),
          'Carbohydrates':
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
          'Fats': fatCalories(widget.fat, nServings, oldValue),
          'totalCalories': totalCalories(
              proteinCalories(widget.protein, nServings, oldValue),
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
              fatCalories(widget.fat, nServings, oldValue),
              oldValue)
        }).then((value) async {
          final result = await widget.myFunction();
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Food logged'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        ;
      }

      if (selectedMeal == 'Snack') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(curr_id)
            .collection('CalorieTrack')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .collection('Snack')
            .add({
          'foodName': widget.foodId,
          'Meal': selectedMeal,
          'Protein': proteinCalories(widget.protein, nServings, oldValue),
          'Carbohydrates':
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
          'Fats': fatCalories(widget.fat, nServings, oldValue),
          'totalCalories': totalCalories(
              proteinCalories(widget.protein, nServings, oldValue),
              CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
              fatCalories(widget.fat, nServings, oldValue),
              oldValue)
        }).then((value) async {
          final result = await widget.myFunction();

          Navigator.of(context).pop();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Food logged'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        ;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    foodIemStat = {
      'Protein': proteinCalories(widget.protein, nServings, oldValue),
      'Carbs': CarbohydratesCalories(widget.carbohydrates, nServings, oldValue),
      'fat': fatCalories(widget.fat, nServings, oldValue),
    };

    final screenWidth = MediaQuery.of(context).size.width - edgePadding * 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adding Food',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.foodId,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          FontAwesomeIcons.solidCheckCircle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meal',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        child: CustomDropdown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Select a Meal';
                              }
                            },
                            items: meal,
                            onChanged: (meal) {
                              selectedMeal = meal;
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of Servings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.16,
                        child: TextFormField(
                          onChanged: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                nServings = 1;
                              });
                            } else {
                              setState(() {
                                nServings = int.parse(value.toString());
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              nServingsController.text = '1';
                              return 'Insert Servings.';
                            }
                          },
                          controller: nServingsController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serving size',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: widget.serSize,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Total Calories',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20),
                      PieChart(
                        dataMap: foodIemStat,
                        colorList: colorList,
                        chartRadius: screenWidth * 0.4,
                        chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: true,
                          showChartValueBackground: false,
                        ),
                        chartType: ChartType.ring,
                        legendOptions: LegendOptions(
                            showLegends: true,
                            legendTextStyle: TextStyle(fontSize: 18)),
                        centerText:
                            '${totalCalories(proteinCalories(widget.protein, nServings, oldValue), CarbohydratesCalories(widget.carbohydrates, nServings, oldValue), fatCalories(widget.fat, nServings, oldValue), oldValue)}',
                      ),
                    ],
                  ),
                ),
                Gap(20),
                ElevatedButton(onPressed: Add, child: const Text('Add'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double proteinCalories(double protein, int nServings, double oldProtein) {
  double proteinCalories = oldProtein + ((protein * 4) * nServings);

  return proteinCalories;
}

double CarbohydratesCalories(double carbs, int nServings, double oldCarbs) {
  double carbsCalories = oldCarbs + ((carbs * 4) * nServings);

  return carbsCalories;
}

double fatCalories(double fat, int nServings, double oldFats) {
  double fatCalories = oldFats + ((fat * 9) * nServings);

  return fatCalories;
}

double totalCalories(
    double protein, double carbs, double fat, double oldCalories) {
  return protein + carbs + fat + oldCalories;
}
