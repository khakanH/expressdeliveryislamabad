import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserHistory extends StatefulWidget {
  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  Widget _historyItem(
      {DateTime time, String price, String point, String point_des}) {
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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('EEEE, d MMM, yyyy').format(time)}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '$price PKR',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // TODO according to design
          children: [
            ListTile(
              leading: Image.asset('assets/pickng',
                width: 24,
                height: 24,),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              title: Align(
                alignment: Alignment(-1.4, 0),
                child: Text(
                  point,
                  style: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/drop.png',
                width: 24,
                height: 24,
              ),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              title: Align(
                alignment: Alignment(-1.4, 0),
                child: Text(
                  point_des,
                  style: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
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
          'HISTORY',
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .where('customerID',
                  isEqualTo: '${FirebaseAuth.instance.currentUser.uid}')
              .snapshots(),
          builder: (context, querySnapshot) {
            if (querySnapshot.hasError && !querySnapshot.hasData) {
              return Container(
                padding: EdgeInsets.all(
                  30,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (querySnapshot.hasData) {
              print('${querySnapshot.data.docs.length}');
              return Container(
                padding: EdgeInsets.all(
                  30,
                ),
                child: ListView.builder(
                    itemCount: querySnapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot queryDocumentSnapshot =
                          querySnapshot.data.docs[index];
                      OrderModel orderModel = new OrderModel(
                        pickUpAddress:
                            queryDocumentSnapshot.get('pickUpAddress'),
                        dropAddress: queryDocumentSnapshot.get('dropAddress'),
                        deliveryCharges:
                            queryDocumentSnapshot.get('deliveryCharges'),
                        timestamp:
                            queryDocumentSnapshot.get('timestamp').toDate(),
                      );
                      return _historyItem(
                          point: orderModel.pickUpAddress,
                          point_des: orderModel.dropAddress,
                          time: orderModel.timestamp,
                          price: orderModel.deliveryCharges.toString());
                    }),
              );
            }
            return Container(
              padding: EdgeInsets.all(
                30,
              ),
            );
          }),
    );
  }
}
