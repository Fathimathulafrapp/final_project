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
import '../viewpages/view Place.dart';
import '../viewpages/view staff.dart';
import '../viewpages/viewMakeup.dart';





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
      home:  Addmakeup(),
    );
  }
}



class Addmakeup extends StatefulWidget {
  const Addmakeup({super.key});

  @override
  State<Addmakeup> createState() => _AddmakeupState();
}

class _AddmakeupState extends State<Addmakeup> {
  final CollectionReference makeup = FirebaseFirestore.instance.collection('makeup');
  TextEditingController makeupname = TextEditingController();
  TextEditingController makeupplace = TextEditingController();
  TextEditingController makeupdetails = TextEditingController();
  TextEditingController makeupphone = TextEditingController();
  TextEditingController makeupinsta = TextEditingController();

  void addStaff(){
    final data = {
      'Name':makeupname.text,
      'Place':makeupplace.text,
      'Details':makeupdetails.text,
      'Contact':makeupphone.text,
      'Insta_ID':makeupinsta.text,

    };

    makeup.add(data);
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
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




  var formkey = GlobalKey<FormState>();


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

            body: Form(
              key: formkey,
              child: Stack(
                  children: [
                    Positioned(
                        left: 20,
                        right: 15,
                        top: 20,
                        bottom: 20,
                        child: Container(
                          height: 720,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          SingleChildScrollView(
                            child: Card(
                              child: Container(
                                color: Colors.white,
                                width: 200,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: FutureBuilder(
                                          future: _loadImages(),
                                          builder: (context,  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                            return Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 30),
                                                  child: CircleAvatar(
                                                    radius: 80.0,
                                                    backgroundImage: NetworkImage('https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI='),
                                                    child: ListView.builder(
                                                      itemCount: snapshot.data?.length ?? 0,
                                                      itemBuilder: (context, index) {
                                                        final Map<String, dynamic> image = snapshot.data![index];
                                                        return Container(

                                                          child: Image(image: NetworkImage(image['url']),),
                                                        );
                                                        // return CircleAvatar(
                                                        //   radius: 80.0,
                                                        //   backgroundImage: NetworkImage(image['url']),
                                                        // );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Positioned(child: IconButton(
                                                  onPressed: (){
                                                    showModalBottomSheet(context: context, builder: ((builder) => bottomSheet(context)));
                                                  },icon: Icon(Icons.add_a_photo,size: 32,color: Colors.teal[800],),
                                                ),
                                                  bottom: -10,
                                                  left: 120,
                                                )                            ],
                                            );
                                          }
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,top: 30),
                                      child: Row(
                                        children: [
                                          Text("Name :",style: GoogleFonts.alegreya(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 20,
                                            color: Colors.teal[800],),),
                                          SizedBox(width: 32,),
                                          Container(
                                            height: 50,
                                            width: 200,
                                            child: TextFormField(
                                              controller: makeupname,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  )
                                              ),
                                            ),
                                          )
                                        ],),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 15),
                                      child: Row(
                                        children: [
                                          Text("Place:",style: GoogleFonts.alegreya(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 20,
                                            color: Colors.teal[800],),),
                                          SizedBox(width: 52,),
                                          Container(
                                            height: 50,
                                            width: 200,
                                            child: TextFormField(
                                              controller: makeupplace,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  )
                                              ),
                                            ),
                                          )
                                        ],),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12,top: 15),
                                      child: Row(
                                        children: [
                                          Text("Details :",style: GoogleFonts.alegreya(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 20,
                                            color: Colors.teal[800],),),
                                          SizedBox(width:18,),
                                          Container(
                                            height: 50,
                                            width:200,
                                            child: TextFormField(
                                              controller: makeupdetails,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  )
                                              ),
                                            ),
                                          )
                                        ],),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6,top: 15),
                                      child: Row(
                                        children: [
                                          Text("Phone :",style: GoogleFonts.alegreya(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 20,
                                            color: Colors.teal[800],),),
                                          SizedBox(width: 50,),
                                          Container(
                                            height: 50,
                                            width: 200,
                                            child: TextFormField(
                                              controller: makeupphone,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  )
                                              ),
                                            ),
                                          )
                                        ],),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12,top: 15),
                                      child: Row(
                                        children: [
                                          Text("Insta_ID :",style: GoogleFonts.alegreya(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 20,
                                            color: Colors.teal[800],),),
                                          SizedBox(width: 28,),
                                          Container(
                                            height: 50,
                                            width: 200,
                                            child: TextFormField(
                                              controller: makeupinsta,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  )
                                              ),
                                            ),
                                          )
                                        ],),
                                    ),

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10,right: 20,top: 10),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                addStaff();
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Addmakeup()));
                                              },
                                              child: Text(
                                                "Add Makeup Team ",
                                                style: GoogleFonts.alegreya(
                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(60, 50),
                                                primary: Colors.teal[800],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8)),
                                              )),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 1,top: 30,bottom: 20),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => viewMakeup()));
                                              },
                                              child: Text(
                                                "View Place",
                                                style: GoogleFonts.alegreya(
                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(100,50),
                                                primary: Colors.teal[800],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8)),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                  ]
              ),
            )));
  }
  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: 300,
      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
      ),
      child: Column(
        children: [
          Text("Choose Profile Photo",
            style: GoogleFonts.alegreya(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 26,
              color: Colors.teal[800],),),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera, color: Colors.teal[800], size: 26,),
                onPressed: () => _upload('camera'),
                label: Text("Camera",
                  style: GoogleFonts.alegreya(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 22,
                    color: Colors.teal[800],),
                ),), SizedBox(width: 35,),
              TextButton.icon(
                icon: Icon(Icons.image, color: Colors.teal[800], size: 26,),
                onPressed: () => _upload('gallery'),
                label: Text("Gallery",
                    style: GoogleFonts.alegreya(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 22,
                        color: Colors.teal[800])),
              )
            ],
          )
        ],
      ),
    );
  }



}