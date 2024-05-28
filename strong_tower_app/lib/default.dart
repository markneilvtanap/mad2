import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:strong_tower_app/login.dart';

import 'package:strong_tower_app/screens/user/home.dart';
import 'package:strong_tower_app/screens/user/logs.dart';
import 'package:strong_tower_app/screens/user/track.dart';

class DefaultScreen extends StatefulWidget {
  DefaultScreen({super.key});

  @override
  State<DefaultScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DefaultScreen> {
  List icons = [
    Icons.calendar_month_rounded,
    Icons.home,
    Icons.track_changes,
  ];

  Color primary = const Color.fromARGB(255, 0, 139, 252);

  int currentIndex = 1;
  String curr_userName = '';
  String curr_userEmail = '';
  String curr_id = FirebaseAuth.instance.currentUser!.uid;

  Future<void> name() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(curr_id).get();

    curr_userName = snap['username'];
    curr_userEmail = snap['email'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        shadowColor: Colors.black,
        elevation: 5,
        title: const Text(
          'Strong Tower App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Ionicons.scan)),
        ],
      ),
      drawer: Drawer(
        elevation: 5,
        shadowColor: Colors.red,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                curr_userName,
                style: TextStyle(color: Colors.white),
              ),
              accountEmail:
                  Text(curr_userEmail, style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/strong_tower_image.png'), // Adjust the path to match your image file
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/strong_tower_image_back.png'), // Adjust the path to match your image file
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                // Navigator.pop(context);
              },
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
                // Navigator.pop(context);
              },
              title: const Text('Log-out'),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          new LogsScreen(),
          new HomeScreen(),
          new CaloritTrackScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < icons.length; i++)
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[i],
                            color: i == currentIndex ? primary : Colors.black,
                            size: i == currentIndex ? 34 : 26,
                          ),
                          i == currentIndex
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: 6,
                                  ),
                                  height: 3,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40))),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ))
            ],
          ),
        ),
      ),
    );
  }
}
