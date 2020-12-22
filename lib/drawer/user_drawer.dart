
import 'package:express_delivery/screens/customer/history_user.dart';
import 'package:express_delivery/screens/customer/notification_user.dart';
import 'package:express_delivery/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              40,
              10,
              20
            ),
            color: Color(0xFFFEBC10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/icon.jpeg'),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    'USER FULL NAME',
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UserHistory()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                  ),
                  title: Text(
                    'NOTIFICATION',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UserNotification()));
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
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
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
