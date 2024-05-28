import 'dart:async';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String curr_id = FirebaseAuth.instance.currentUser!.uid;

  String loggedIn = "--/--";
  String loggedOut = "--/--";
  String scanResult = '';

  String curr_userName = '';
  String strong_Tower_code = "gUNVDWvWjNfoHvd1lobnN8If5LP2";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecord();
    name();
  }

  void _getRecord() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(curr_id)
          .collection('logs')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        loggedIn = snap['loggedIn'];
        loggedOut = snap['loggedOut'];
      });
    } catch (e) {
      setState(() {
        loggedIn = "--/--";
        loggedOut = "--/--";
      });
    }
  }

//qr code
  Future<void> scanQR() async {
    String result = " ";
    try {
      result = await FlutterBarcodeScanner.scanBarcode(
          '#FFFFFF', 'Cancel', true, ScanMode.DEFAULT);

      if (result == strong_Tower_code) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(curr_id)
            .collection('logs')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .get();
        try {
          String loggedIn = snap['loggedIn'];

          setState(() {
            loggedOut = DateFormat('hh:mm a').format(DateTime.now());
          });

          await FirebaseFirestore.instance
              .collection('users')
              .doc(curr_id)
              .collection('logs')
              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
              .update({
            'loggedIn': loggedIn,
            'loggedOut': DateFormat('hh:mm a').format(DateTime.now())
          });
        } catch (e) {
          setState(() {
            loggedIn = DateFormat('hh:mm a').format(DateTime.now());
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(curr_id)
              .collection('logs')
              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
              .set({
            'loggedIn': DateFormat('hh:mm a').format(DateTime.now()),
            'loggedOut': "--/--",
            'date': Timestamp.now(),
          });
        }
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'QR CODE UNRECOGNIZED',
            text: 'Qr code is Different from the QR Code of Strong Tower Gym');
      }
    } catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'QR CODE ERROR',
          text: 'Error Initiating the Qr Code Scanner');
    }
  }

  Future<void> name() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(curr_id).get();

    curr_userName = snap['username'];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<SlideActionState> key = GlobalKey();
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 12),
            child: Text(
              "Welcome,  $curr_userName",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Gap(20),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 12),
            child: Text(
              "Today Status",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Gap(10),
          Container(
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logged In",
                        style: TextStyle(
                            fontSize: screenWidth / 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        loggedIn,
                        style: TextStyle(
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logged Out",
                        style: TextStyle(
                            fontSize: screenWidth / 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        loggedOut,
                        style: TextStyle(
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Gap(30),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 18,
                  ),
                  children: [
                    TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 18,
                        ))
                  ]),
            ),
          ),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth / 18,
                    ),
                  ),
                );
              }),
          Gap(30),
          loggedOut == '--/--'
              ? GestureDetector(
                  onTap: scanQR,
                  child: Container(
                    width: screenWidth / 1,
                    height: screenWidth / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.expand,
                              color: Colors.black,
                              size: 110,
                            ),
                            Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.black,
                              size: 40,
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            loggedIn == '--/--'
                                ? 'Scan to Logged in'
                                : 'Scan to Logged out',
                            style: TextStyle(
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Text(
                  'You Have Logged In and Logged out today :)',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth / 30,
                  ),
                )
        ],
      ),
    ));
  }
}
