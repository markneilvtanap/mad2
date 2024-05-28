import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:strong_tower_app/addfood.dart';
import 'package:strong_tower_app/default.dart';
import 'package:strong_tower_app/firebase_options.dart';
import 'package:strong_tower_app/login.dart';
import 'package:strong_tower_app/screens/registerParts/register01.dart';
import 'package:strong_tower_app/screens/registerParts/register03.dart';
import 'package:strong_tower_app/screens/registerParts/registerLast.dart';
import 'package:strong_tower_app/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(Strong_Tower());
}

class Strong_Tower extends StatelessWidget {
  const Strong_Tower({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: addFoodScreen(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.red,
              body: Image.asset(
                'assets/images/strong_tower_image.png',
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
              ),
            );
          }

          if (snapshot.hasData) {
            return DefaultScreen();
          }
          return SplashScreen();
        },
      ),
      localizationsDelegates: [MonthYearPickerLocalizations.delegate],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
