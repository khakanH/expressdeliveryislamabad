import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserNotification extends StatefulWidget {
  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  Widget _notificationItem({String heading, String day, String data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.black54,
          height: 30,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                heading,
                style: TextStyle(
                  color: Color(0xFF29146F),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                day,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: Text(
            data,
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF29146F),
          ),
          title: Text(
            'NOTIFICATIONS',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),
              _notificationItem(
                  heading: 'LOREM', data: 'sdfskdfl', day: 'yesterday'),

            ],
          ),
        )
    );
  }
}
