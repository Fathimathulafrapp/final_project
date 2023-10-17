import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../viewpages/viewfood.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home:  Addfood(),
    );
  }
}



class Addfood extends StatefulWidget {
  const Addfood({super.key});

  @override
  State<Addfood> createState() => _AddfoodState();
}

class _AddfoodState extends State<Addfood> {
  final CollectionReference feedback = FirebaseFirestore.instance.collection('feedback');
  TextEditingController feedbacktxt = TextEditingController();

  void addStaff() {
    final data = {
      'Feedback': feedbacktxt.text,


    };

    feedback.add(data);
  }

  @override
  Widget build(BuildContext context) {
    final genderSelectionTile = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),

        ],
      ),
    );
    return SafeArea(
        child: Scaffold(

            body: Center(
              child: Container(
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(15)),
                child: Center(
                  child: TextFormField(
                    maxLines: 5,
                    controller: feedbacktxt,

                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined,color: Colors.teal[800]),
                        hintText: "Raise Your Voice",
                        hintStyle: TextStyle(height: 1.5,color: Colors.teal[800]),
                        border: InputBorder.none),
                  ),
                ),
              ),

            )




              ),


    );
  }




}