import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignRider extends StatefulWidget {
  final OrderModel orderModel;

  const AssignRider({Key key, @required this.orderModel}) : super(key: key);

  @override
  _AssignRiderState createState() => _AssignRiderState();
}

class _AssignRiderState extends State<AssignRider> {
  GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController _riderPhoneControl = new TextEditingController();
  TextEditingController _riderNameControl = new TextEditingController();

  String rider_id;

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        print('order id: ${widget.orderModel.id}');

        if (_key.currentState.validate()) {
          try {
            await FirestoreService().updateOrder(
                OrderModel(
                  customerID: widget.orderModel.id,
                  customerFullNname: widget.orderModel.customerFullNname,
                  customerPhoneNum: widget.orderModel.customerPhoneNum,
                  riderID: rider_id,
                  riderFullName: _riderNameControl.text,
                  riderPhoneNum: _riderPhoneControl.text,
                  deliveryCharges: widget.orderModel.deliveryCharges,
                  pickUpAddress: widget.orderModel.pickUpAddress,
                  dropAddress: widget.orderModel.dropAddress,
                  pickUpGeoPoint: widget.orderModel.pickUpGeoPoint,
                  droppGeoPoint: widget.orderModel.droppGeoPoint,
                  description: widget.orderModel.description,
                  status: 'assigned',
                  timestamp: widget.orderModel.timestamp,
                  // timestamp: Timestamp.now().toDate(),
                ),
                widget.orderModel.id);
            Navigator.pop(context);
          } catch (e) {
            print(e.toString());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFEBC10), Color(0xFFFEBC10)])),
        child: Text(
          'ASSIGN',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'ASSIGN RIDER',
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
      body: Container(
        padding: EdgeInsets.all(
          30,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // customer data
                TextFormField(
                  initialValue: widget.orderModel.customerFullNname,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Customer Full Name',
                  ),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  initialValue: widget.orderModel.customerPhoneNum,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Customer Phone Number',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                // rider data

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("riders")
                        .where('authID', isNotEqualTo: '')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError && !snapshot.hasData) {
                        print(snapshot.error.toString());
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        List<DropdownMenuItem> riders = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          riders.add(
                            DropdownMenuItem(
                              child: Text(
                                snap.get('fullName'),
                                style: TextStyle(color: Color(0xff11b719)),
                              ),
                              value: snap,
                            ),
                          );
                        }
                        return Container(
                          child: DropdownButton(
                            items: riders,
                            isExpanded: true,
                            onChanged: (snap) {
                              rider_id = snap.get('authID');
                              print(rider_id);
                              _riderNameControl.text = snap.get('fullName');
                              _riderPhoneControl.text = snap.get('phone');
                            },
                            hint: new Text(
                              "Choose Rider",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),

                TextFormField(
                  controller: _riderNameControl,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Selected Rider',
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String arg) {
                    if (arg.isEmpty)
                      return 'Enter Rider';
                    else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _riderPhoneControl,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Rider Phone Number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String arg) {
                    if (arg.isEmpty)
                      return 'Rider Phone Required';
                    else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: '${widget.orderModel.deliveryCharges} PKR',
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Delivery Charges',
                  ),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                // pick and drop data
                TextFormField(
                  initialValue: widget.orderModel.pickUpAddress,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Pick Up Address',
                  ),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  initialValue: widget.orderModel.dropAddress,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Drop Address',
                  ),
                  keyboardType: TextInputType.name,
                ),

                // Order description
                TextFormField(
                  initialValue: widget.orderModel.description,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Oder Description',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                // order status
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: widget.orderModel.status,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    hintMaxLines: 3,
                  ),
                  keyboardType: TextInputType.streetAddress,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: widget.orderModel.timestamp.toString(),
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'DateTime',
                    hintMaxLines: 3,
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
