import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:path/path.dart' as path;

import '../userhome.dart';





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
      home: bookdecoration(),
    );
  }
}



class bookdecoration extends StatefulWidget {
  @override
  State<bookdecoration> createState() => _bookdecorationState();
}

class _bookdecorationState extends State<bookdecoration> {

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return files;
  }

  final CollectionReference menu = FirebaseFirestore.instance.collection('decoration');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:StreamBuilder(
            stream: menu.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40,left: 30,right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.49
                        ),
                        itemCount: snapshot.data!.docs.length ?? 1 ,
                        itemBuilder: (context,index){
                          final DocumentSnapshot foodsnap = snapshot.data!.docs[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(10,10),
                                      blurRadius: 20,
                                      color: Colors.brown.withOpacity(0.6)
                                  )
                                ]
                            ),

                            height: 10,
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: FutureBuilder(
                                    future: _loadImages(),
                                    builder: (context,
                                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return ListView.builder(
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) {
                                            final Map<String, dynamic> image =
                                            snapshot.data![index];
                                            return Card(
                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Image.network(image['url'],fit: BoxFit.cover,),
                                                )
                                            );
                                          },
                                        );
                                      }

                                      return Container();
                                    },
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Text(foodsnap['name'],style: GoogleFonts.alegreya(
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 22,
                                    color: Colors.teal[800],),),
                                ), Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child:Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text('',style: TextStyle(fontSize: 16,color: Colors.teal[800]),),
                                      ),SizedBox(width: 4,),
                                      Text(foodsnap['phone'],style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 24,
                                        color: Colors.teal[800],),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Text(foodsnap['desgination'],style: GoogleFonts.alegreya(
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 18,
                                    color: Colors.teal[800],),),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Text(foodsnap['instaid'],style: GoogleFonts.alegreya(
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 18,
                                    color: Colors.teal[800],),),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Text(foodsnap['details'],style: GoogleFonts.alegreya(
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 18,
                                    color: Colors.teal[800],),),
                                ),

                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15,left: 20,bottom: 20),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            //
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ()));
                                          },
                                          child: Text(
                                            "Book Now",
                                            style: GoogleFonts.alegreya(
                                                textStyle: Theme.of(context).textTheme.headline4,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(50,100
                                            ),
                                            primary: Colors.teal[800],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8)),
                                          )),
                                    ),SizedBox(width: 15,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,bottom: 20,top: 15),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => userhome()));
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.alegreya(
                                                textStyle: Theme.of(context).textTheme.headline4,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(100,
                                                50),
                                            primary: Colors.teal[800],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8)),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                        }),
                  ),
                );

              }
              // snapshot.data is QuerySnapshot than I access .docs to get List<QueryDocumentSnapshot>
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}