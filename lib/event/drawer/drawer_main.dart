import 'package:final_project/event/viewpages/view%20staff.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../addpages/Bridal_makeup.dart';
import '../addpages/add decoration.dart';
import '../addpages/addfood.dart';
import '../addpages/addplaces.dart';
import '../addpages/addstaff.dart';
import '../dashboard.dart';
import '../viewpages/view Place.dart';
import 'drawer_header.dart';

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
      home:  Drawerhome(),
    );
  }
}



class Drawerhome extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Drawerhome> {
  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {

    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = Dashboard();
    } else if (currentPage == DrawerSections.contacts) {
      container = StaffManage();
    } else if (currentPage == DrawerSections.events) {
      container = Addplace();
    } else if (currentPage == DrawerSections.notes) {
      container = Add_decoration();
    } else if (currentPage == DrawerSections.settings) {
      container = Addfood();
    } else if (currentPage == DrawerSections.notifications) {
      container = Addmakeup();
    } else if (currentPage == DrawerSections.privacy_policy) {
      // container = PrivacyPolicyPage();
    } else if (currentPage == DrawerSections.send_feedback) {
      // container = SendFeedbackPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text("Event Management"),
      ),
      body: container,
      drawer: Drawer(
        backgroundColor: Colors.teal,
        width: 280,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.home,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Staff", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "Desgination", Icons.place,
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Event", Icons.event,
              currentPage == DrawerSections.notes ? true : false),
          menuItem(5, "Food Menu", Icons.fastfood_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          menuItem(6, "Make Over", Icons.brush,
              currentPage == DrawerSections.privacy_policy ? true : false),
          Divider(),
          menuItem(7, "Settings", Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false),
          menuItem(8, "Notifications", Icons.notifications_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          Divider(),
          menuItem(8, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(9, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[400] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.notifications;
            } else if (id == 7) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 8) {
              currentPage = DrawerSections.send_feedback;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  notes,
  settings,
  notifications,
  privacy_policy,
  send_feedback,
}