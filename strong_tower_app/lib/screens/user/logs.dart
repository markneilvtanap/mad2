import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() {
  runApp(LogsScreen());
}

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  String curr_id = FirebaseAuth.instance.currentUser!.uid;

  String _month = DateFormat('MMMM').format(DateTime.now());

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void change(DateTime? month) {
      _month = DateFormat('MMMM').format(month!);

      setState(() {});
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 12),
              child: Text(
                "My Gym Attendance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(18),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    _month
                    // == ''
                    // ? DateFormat('MMMM').format(DateTime.now())
                    // : _month
                    ,
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
                    .collection('logs')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data!.docs;

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return DateFormat('MMMM')
                                    .format(data[index]['date'].toDate()) ==
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          ).format(
                                              data[index]['date'].toDate()),
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
                                            "Logged In",
                                            style: TextStyle(
                                                fontSize: screenWidth / 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data[index]['loggedIn'],
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
                                            "Logged Out",
                                            style: TextStyle(
                                                fontSize: screenWidth / 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data[index]['loggedOut'],
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
      ),
    );
  }
}
