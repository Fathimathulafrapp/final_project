import 'package:final_project/event/login_signup/Register.dart';
import 'package:final_project/event/login_signup/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
      theme: ThemeData(primarySwatch: Colors.teal),
      home:  homepage(),
    );
  }
}

class homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 150,),
          Text("Let's Plan The Evnent Together...",style: GoogleFonts.seaweedScript(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,

            color: Colors.teal[800],)),

          Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/event3.jpg"),fit: BoxFit.cover)),

            ),
          ),

          SizedBox(height: 15,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300,50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  primary: Colors.teal[800]),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  Register()));
              }, child: Text("SiGN-UP",style: GoogleFonts.alegreya(
          textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 20,
              color: Colors.white),)), SizedBox(height: 20,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300,50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  primary: Colors.teal[800]),

              // style: ButtonStyle(
              //
              //
              //   backgroundColor: MaterialStateProperty.all(Colors.green[900]),
              //   minimumSize: MaterialStateProperty.all(Size(320, 50)),
              //
              // ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              }, child: Text("LOG-IN",style: GoogleFonts.alegreya(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 20,
              color: Colors.white),)),
          SizedBox(height: 20,),
          Text("EVERY EVENT SOULD TO BE PERFECT !!",style: GoogleFonts.racingSansOne(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 20,

            color: Colors.teal[800],))
        ],
      ),
    );
  }
}
