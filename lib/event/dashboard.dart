import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     body: Center(
       child: Padding(
         padding: const EdgeInsets.only(left: 30,right: 30,top: 200),
         child: Column(
           children: [
             Image(image:AssetImage("assets/images/homeimage2.png") ,),
             Text("'Life is a Party Dress for it'",style: GoogleFonts.seaweedScript(
                 textStyle: Theme.of(context).textTheme.headline4,
     fontSize: 18,

     color: Colors.teal[800],)),

           ],
         ),
       ),
     ),
   );
  }

}