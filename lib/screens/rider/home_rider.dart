import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiderHome extends StatefulWidget {
  @override
  _RiderHomeState createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rider Home',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Color(0xFF29146F),
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Container(
            color: Color(0xFFFEBC10),
            child: FlatButton(
              child: Text('logout'),
              textColor: Color(0xFF29146F),

              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ),
      ),
    );
  }
}
