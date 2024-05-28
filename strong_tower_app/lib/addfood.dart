import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addFoodScreen extends StatelessWidget {
  const addFoodScreen({super.key});

  void add() async {
    final insert = await FirebaseFirestore.instance
        .collection('foods')
        .doc('White Rice (1 cup cooked)')
        .set({
      'Calories': 205,
      'Carbohydrates': 45,
      'Fat': 0.4,
      'Protein': 4.2,
      'foodName': 'White Rice',
      'serSize': '1 cup cooked',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ElevatedButton(onPressed: add, child: const Text('add'))],
      ),
    );
  }
}
