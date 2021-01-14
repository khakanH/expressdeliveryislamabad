
import 'package:express_delivery/screens/customer/history_user.dart';
import 'package:express_delivery/screens/get_in_page.dart';
import 'package:express_delivery/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  final String fullName;
  UserDrawer({Key key, this.fullName}) : super(key: key);

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

                // ListTile(
                //   leading: Icon(
                //     Icons.history,
                //   ),
                //   title: Text(
                //     'PLACE ORDER',
                //     style: TextStyle(
                //       color: Color(0xFF29146F),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     // _checkIfAnyActiveOrder(context);
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (context) => PlaceOrder(fullName: fullName,)));
                //   },
                // ),
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
                        MaterialPageRoute(builder: (context) => UserHistory()));
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.notifications_outlined,
                //   ),
                //   title: Text(
                //     'NOTIFICATION',
                //     style: TextStyle(
                //       color: Color(0xFF29146F),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => UserNotification()));
                //   },
                // ),
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
                    Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetInPage()),
                            (route) => false);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // void _checkIfAnyActiveOrder(BuildContext context) {
  //   FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
  //       .where('status', whereIn: ['pending', 'assigned'])
  //       .get()
  //       .then((querySnaphot) {
  //         if (querySnaphot.size == 1 && querySnaphot.docs.first.exists) {
  //           print(
  //               'Already an order for ${querySnaphot.docs.first.get('customerID')} is in ${querySnaphot.docs.first.get('status')}');
  //           Scaffold.of(context).showSnackBar(SnackBar(
  //             content: Text(
  //               'Already an order for ${querySnaphot.docs.first.get('customerID')} is in ${querySnaphot.docs.first.get('status')}',
  //               style: TextStyle(
  //                 color: Colors.white,
  //               ),
  //             ),
  //             duration: Duration(seconds: 5),
  //             backgroundColor: Color(0xFF29146F),
  //           ));
  //         } else {
  //           print('No order with pending | assigned found');
  //         }
  //       });
  // }
}
