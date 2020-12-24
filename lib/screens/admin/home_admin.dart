import 'package:express_delivery/drawer/admin_drawer.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/screens/admin/assign_rider.dart';
import 'package:express_delivery/screens/admin/order_details.dart';
import 'package:express_delivery/screens/admin/orders.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHome extends StatefulWidget {

  final String fullName;

  const AdminHome({Key key, this.fullName}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WELCOME',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF29146F),
        elevation: 0,
      ),
      drawer: AdminDrawer(fullName: '${widget.fullName}',),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Requested Orders',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              StreamBuilder<List<OrderModel>>(
                  stream:
                  FirestoreService().getOrders(status: 'pending'),
                  builder: (context,snapshot) {
                    if (snapshot.hasError && !snapshot.hasData) {
                      print(snapshot.error.toString());
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasData){
                      return SingleChildScrollView(
                        child: Container(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int) {
                              OrderModel orderModel = snapshot.data[int];
                              return ListTile(
                                leading: Icon(
                                  Icons.pending,
                                  color: Color(0xFFFEBC10),
                                ),
                                title: Text(
                                  orderModel.customerFullNname,
                                  style: TextStyle(
                                    color: Color(0xFF29146F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Description: ${orderModel.description}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => AssignRider(orderModel: orderModel)));
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
              SizedBox(height: 20,),
              Text(
                'In Porgress',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              StreamBuilder<List<OrderModel>>(
                  stream:
                  FirestoreService().getOrders(status: 'assigned'),
                  builder: (context,snapshot) {
                    if (snapshot.hasError && !snapshot.hasData) {
                      print(snapshot.error.toString());
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasData){
                      return SingleChildScrollView(
                        child: Container(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int) {
                              OrderModel orderModel = snapshot.data[int];
                              return ListTile(
                                leading: Icon(
                                  Icons.assignment,
                                  color: Color(0xFFFEBC10),
                                ),
                                title: Text(
                                  orderModel.customerFullNname,
                                  style: TextStyle(
                                    color: Color(0xFF29146F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Description: ${orderModel.description}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => OrderDetails(orderModel: orderModel)));
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
