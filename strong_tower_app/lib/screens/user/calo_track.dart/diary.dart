import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DiaryFoodScreen extends StatefulWidget {
  DiaryFoodScreen({super.key, required this.goal, required this.intake});

  double goal;
  double intake;
  @override
  State<DiaryFoodScreen> createState() => _DiaryFoodScreenState();
}

class _DiaryFoodScreenState extends State<DiaryFoodScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final curr_id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(247, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Food Diary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Gap(20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calorie Remaining',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: screenWidth * 0.20,
                              child: Column(
                                children: [
                                  Text('${widget.goal}',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Goal'),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.15,
                              child: Column(
                                children: [
                                  Text('-',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20)),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.20,
                              child: Column(
                                children: [
                                  Text('${widget.intake}',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(' Food'),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.15,
                              child: Column(
                                children: [
                                  Text('=',
                                      style: TextStyle(
                                          fontSize: screenWidth / 20)),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.20,
                              child: Column(
                                children: [
                                  Text('${widget.goal - widget.intake}',
                                      style: TextStyle(
                                          fontSize: screenWidth / 22,
                                          fontWeight: FontWeight.bold)),
                                  Text(' Remaining'),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(20),
            Container(
                width: screenWidth,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Breakfast',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Add food',
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                          ),
                        ))
                  ],
                )),
            Gap(15),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(curr_id)
                    .collection('CalorieTrack')
                    .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                    .collection('Breakfast')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final document = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: document.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text('${document[index]['foodName']}'),
                            trailing:
                                Text('${document[index]['totalCalories']}'),
                          ),
                        );
                      },
                    );
                  }

                  return Text('No Food Added');
                },
              ),
            ),
            Gap(20),
            Container(
                width: screenWidth,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lunch',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Add food',
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                          ),
                        ))
                  ],
                )),
            Gap(15),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(curr_id)
                    .collection('CalorieTrack')
                    .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                    .collection('Lunch')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final document = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: document.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('${document[index]['foodName']}'),
                          trailing: Text('${document[index]['totalCalories']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Gap(20),
            Container(
                width: screenWidth,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dinner',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Add food',
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                          ),
                        ))
                  ],
                )),
            Gap(15),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(curr_id)
                    .collection('CalorieTrack')
                    .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                    .collection('Dinner')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final document = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: document.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text('${document[index]['foodName']}'),
                          trailing: Text('${document[index]['totalCalories']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Gap(20),
            Container(
                width: screenWidth,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Snack',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Add food',
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                          ),
                        ))
                  ],
                )),
            Gap(15),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(curr_id)
                    .collection('CalorieTrack')
                    .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                    .collection('Snack')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final document = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: document.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text('${document[index]['foodName']}'),
                          trailing: Text('${document[index]['totalCalories']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
