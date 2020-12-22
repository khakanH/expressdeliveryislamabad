import 'package:express_delivery/screens/admin/order_details.dart';
import 'package:express_delivery/screens/admin/orders.dart';
import 'package:express_delivery/screens/admin/add_rider.dart';
import 'package:express_delivery/screens/admin/rider_list.dart';
import 'package:express_delivery/services/auth.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
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
                    Icons.label_important,
                    color: Color(0xFFFEBC10),
                  ),
                  title: Text(
                    'PROFILE',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => OrderDetails(order_id: '12345')));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.list,
                    color: Color(0xFFFEBC10),
                  ),
                  title: Text(
                    'RIDER LIST',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => RiderList()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Color(0xFFFEBC10),
                  ),
                  title: Text(
                    'ADD RIDER',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AddRider()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.done,
                    color: Color(0xFFFEBC10),
                  ),
                  title: Text(
                    'COMPLETE ORDERS',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Orders(order_status: 'complete',)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Color(0xFFFEBC10),
                  ),
                  title: Text(
                    'COMPLETE CANCELED',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Orders(order_status: 'canceled',)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xFFFEBC10),
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
