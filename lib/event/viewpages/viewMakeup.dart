import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/event/viewpages/view%20staff.dart';
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

import '../viewmore/makeup.dart';

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
      home: viewMakeup(),
    );
  }
}
class viewMakeup extends StatefulWidget {
  @override
  State<viewMakeup> createState() => _viewMakeupState();
}

class _viewMakeupState extends State<viewMakeup> {
  final CollectionReference makeup = FirebaseFirestore.instance.collection('makeup');
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
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
        fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:StreamBuilder(
            stream: makeup.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40,left: 10,right: 10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>makeupmore()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.7
                          ),
                          itemCount: snapshot.data!.docs.length ,
                          itemBuilder: (context,index){
                            return Column(
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

                                ]);


                          }),
                    ),
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