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
import '../viewpages/view staff.dart';
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
      home:  StaffManage(),
    );
  }
}



class StaffManage extends StatefulWidget {
  const StaffManage({super.key});

  @override
  State<StaffManage> createState() => _StaffManageState();
}

class _StaffManageState extends State<StaffManage> {
  final CollectionReference staff = FirebaseFirestore.instance.collection('profile');
  TextEditingController staffname = TextEditingController();
  TextEditingController staffgender = TextEditingController();
  TextEditingController staffdob = TextEditingController();
  TextEditingController staffphone = TextEditingController();
  TextEditingController staffemail = TextEditingController();
  TextEditingController staffplace = TextEditingController();
  TextEditingController staffjot = TextEditingController();
  TextEditingController staffdoj = TextEditingController();
  TextEditingController staffexp = TextEditingController();

  void addStaff(){
    final data = {
      'name':staffname.text,
      'gender':staffgender.text,
      'dateofbirth':staffdob.text,
      'phone':staffphone.text,
      'mail':staffemail.text,
      'place':staffplace.text,
      'jobtype':staffjot.text,
      'dateofjoining':staffdoj.text,
      'experience':staffexp.text,
    };

    staff.add(data);
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



  static final Map<String, String> genderMap = {
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
  };
  String _selectedGender = genderMap.keys.first;


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
          CupertinoRadioChoice(
            selectedColor: Colors.teal,
            choices: genderMap,
            onChange: onGenderSelected,
            initialKeyValue: _selectedGender,

          )
        ],
      ),
    );
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
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
                                                    return CircleAvatar(
                                                      radius: 80.0,
                                                      backgroundImage: NetworkImage(image['url']),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Positioned(child: IconButton(
                                              onPressed: (){
                                                showModalBottomSheet(context: context, builder: ((builder) => bottomSheet(context)));
                                              },icon: Icon(Icons.add_a_photo,size: 28,color: Colors.teal,),
                                            ),
                                              bottom: -13,
                                              left: 98,
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
                                      SizedBox(width: 48,),
                                      Container(
                                        height: 50,
                                        width: 190,
                                        child: TextFormField(
                                          controller: staffname,
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
                                      Text("Gender :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.teal[800],),),
                                      SizedBox(width: 32,),
                                      Container(
                                        child: genderSelectionTile,
                                      )
                                    ],),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 15),
                                  child: Row(
                                    children: [
                                      Text("Date Of birth :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.teal[800],),),
                                      SizedBox(width: 15,),
                                      Container(
                                        height: 50,
                                        width: 170,
                                        child: TextFormField(
                                          controller: staffdob,
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
                                      Text("Phone :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width:50,),
                                      Container(
                                        height: 50,
                                        width:190,
                                        child: TextFormField(
                                          controller: staffphone,
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
                                      Text("Email :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width: 56,),
                                      Container(
                                        height: 50,
                                        width: 190,
                                        child: TextFormField(
                                          controller: staffemail,
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
                                      Text("Place :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width: 63,),
                                      Container(
                                        height: 50,
                                        width: 190,
                                        child: TextFormField(
                                          controller: staffplace,
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
                                      Text("Job Type :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width: 40,),
                                      Container(
                                        height: 50,
                                        width: 190,
                                        child: TextFormField(
                                          controller: staffjot,
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
                                      Text("DOJ :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width: 74,),
                                      Container(
                                        height: 50,
                                        width:190,
                                        child: TextFormField(
                                          controller: staffdoj,
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
                                      Text("Experience :",style: GoogleFonts.alegreya(
                                        textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 20,
                                        color: Colors.green[900],),),
                                      SizedBox(width: 20,),
                                      Container(
                                        height: 50,
                                        width: 190,
                                        child: TextFormField(
                                          controller: staffexp,
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
                                  padding: const EdgeInsets.only(left: 50,right: 40,top: 25),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        addStaff();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => StaffManage()));
                                      },
                                      child: Text(
                                        "Add Staff Details",
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 50,right: 40,top: 10,bottom: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile()));
                                      },
                                      child: Text(
                                        "View Staff Details",
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
                                )
                              ],
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


  void onGenderSelected(String genderKey) {
    setState(() {
      _selectedGender = genderKey;
    });
  }
}