import 'dart:async';

import 'package:final_project/event/login_signup/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


import '../../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize a new Firebase App instance
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home:  SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => myappstate();
}

class myappstate extends State {
  @override
  void initState() {
    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>homepage ()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottieimages/event.json', height: 230),
                  ]),
            ),
            Positioned(
          bottom: 245,
                left: 90,
                child: Center(
                  child: Text(
                    "EVENT MANAGEMENT",
                    style: GoogleFonts.seaweedScript(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 25,
                        color: Colors.teal[800],
                        fontWeight: FontWeight.w200),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}