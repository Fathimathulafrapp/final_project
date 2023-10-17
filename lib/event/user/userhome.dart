import 'package:final_project/event/user/usertile.dart';
import 'package:final_project/event/user/viewstaff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../addpages/addstaff.dart';
import '../viewpages/view Decoration.dart';
import '../viewpages/view Place.dart';
import '../viewpages/viewMakeup.dart';
import '../viewpages/viewfood.dart';


class userhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 290),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25)),
                color: Colors.teal[800],
                boxShadow: [
                  BoxShadow(
                      offset: Offset(10,10),
                      blurRadius: 20,
                      color: Colors.brown.withOpacity(1)
                  )
                ],
              ),
            ),
          ),
          Positioned(child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 125, right: 10, bottom: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,childAspectRatio:1,
                          ),
                          children: [
                            CategoryItemTile(
                              CategoryName: "Staff Management",
                              ImagePath: "assets/images/staff.jpg",
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return  viewstf();
                                  },
                                ));
                              },
                            ),
                            CategoryItemTile(
                              CategoryName: "View Desgnation Details",
                              ImagePath: "assets/images/desg.jpg",
                              onPressed: () {

                              },
                            ),
                            CategoryItemTile(
                              CategoryName: "View Decorations",
                              ImagePath: "assets/images/decoration.webp",
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return  viewDecorations();
                                  },
                                ));
                              },
                            ),
                            CategoryItemTile(
                              CategoryName: "View Food Menu ",
                              ImagePath: "assets/images/food.jpg",
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Viewfood ();
                                  },
                                ));
                              },                            ),
                            CategoryItemTile(
                              CategoryName: "View Make Over ",
                              ImagePath: "assets/images/makeup.jpg",
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return viewMakeup ();
                                  },
                                ));
                              },                            ),

                            CategoryItemTile(
                              CategoryName: "Send FeedBack ",
                              ImagePath: "assets/images/feedback.jpg",
                              onPressed: () {

                              },                            ),
                          ]),
                    )
                  ],
                )),
          ))
        ],
      ),

    ));
  }
}