import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/screens/customer/history_user.dart';
import 'package:express_delivery/screens/customer/notification_user.dart';
import 'package:express_delivery/screens/customer/place_order.dart';
import 'package:express_delivery/screens/get_in_page.dart';
import 'package:express_delivery/screens/rider/history_rider.dart';
import 'package:express_delivery/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RiderDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String fullName;
  RiderDrawer({Key key, this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 40, 10, 20),
            color: Color(0xFFFEBC10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/icon.jpeg'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    fullName != null ? fullName : 'USER FULL NAME',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              20,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.history,
                  ),
                  title: Text(
                    'HISTORY',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RiderHistory()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'LOGOUT',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => GetInPage()));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
