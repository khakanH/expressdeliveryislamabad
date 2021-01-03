import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/src/core.dart';

class PlaceOrder extends StatefulWidget {
  final String fullName;

  const PlaceOrder({Key key, this.fullName}) : super(key: key);
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {

  GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController _pickUpController = new TextEditingController();
  TextEditingController _dropController = new TextEditingController();
  TextEditingController _deliveryChargesController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  // TextEditingController _pickUpController = new TextEditingController();

  String _pickUpLocation;
  String _dropLocation;
  int deliveryCharges;

  bool isDisable = false;

  GeoPoint pickUpGeoPoint;
  GeoPoint dropGeoPoint;

  Widget _submitButton() {
    String name = widget.fullName;
    print('${widget.fullName}');
    print(name);
    return InkWell(
      onTap: isDisable ? null : () async {

        if (_key.currentState.validate()) {
          try {
            await FirestoreService().addOrder(OrderModel(
              customerID: '${FirebaseAuth.instance.currentUser.uid}',
              customerFullNname: name,
              customerPhoneNum: '${FirebaseAuth.instance.currentUser.phoneNumber}',
              riderID: '',
              riderFullName: '',
              riderPhoneNum: '',
              deliveryCharges: deliveryCharges,
              pickUpAddress: _pickUpController.text,
              dropAddress: _dropController.text,
              pickUpGeoPoint: pickUpGeoPoint,
              droppGeoPoint: dropGeoPoint,
              description: _descriptionController.text,
              status: 'pending',
              timestamp: Timestamp.now().toDate(),
              // timestamp: Timestamp.now().toDate(),
            ));
            Navigator.pop(context);
          } catch (e) {
            print(e.toString());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isDisable ? [Colors.white, Colors.white] : [Color(0xFFFEBC10), Color(0xFFFEBC10)])),
        child: Text(
          'ORDER',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  void _checkIfAnyActiveOrder(BuildContext context) {
    FirebaseFirestore.instance
        .collection('orders')
        .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('status', whereIn: ['pending', 'assigned'])
        .get()
        .then((querySnaphot) {
      if (querySnaphot.size == 1 && querySnaphot.docs.first.exists) {
        print(
            'Already an order for ${querySnaphot.docs.first.get('customerID')} is in ${querySnaphot.docs.first.get('status')}');
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //     'Already an order for ${querySnaphot.docs.first.get('customerID')} is in ${querySnaphot.docs.first.get('status')}',
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        //   duration: Duration(seconds: 5),
        //   backgroundColor: Color(0xFF29146F),
        // ));
      } else {
        print('No order with pending | assigned found');
        setState(() {
          isDisable = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

   // _checkIfAnyActiveOrder(context);

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
          'ORDER',
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
        padding: EdgeInsets.all(
          30,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [

                Text(
                  isDisable ? 'Already an order is in queue' : '',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),


                ListTile(
                  title: Text('Select Pickup Location'),
                  trailing: IconButton(
                    icon: Icon(Icons.add,
                    color: isDisable ? Colors.white : Color(0xFF29146F),),
                    onPressed: isDisable ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: 'AIzaSyCN-2fyocInwIfJ5EZhLgiWpA9cOY2sWV8',   // Put YOUR OWN KEY here.
                            onPlacePicked: (result) {
                              print('place picker');
                              print(result.formattedAddress);
                              print(result.geometry.location);
                              // print(result.addressComponents[3].longName); // job done, welldone

                              Navigator.of(context).pop();
                              setState(() {
                                String locality = result.addressComponents[3].longName;
                                // String locality = '' ;
                                // List<AddressComponent> pickAdd = result.addressComponents;
                                // if (pickAdd.contains('Islamabad')){
                                //   locality = 'Islamabad';
                                // }
                                // if (pickAdd.contains('Rawalpindi')){
                                //   locality = 'Rawalpindi';
                                // }
                                _pickUpController.text = result.formattedAddress;
                                _pickUpLocation = locality;
                                Location pickUpLocation = result.geometry.location;
                                pickUpGeoPoint = new GeoPoint(pickUpLocation.lat, pickUpLocation.lng);
                                print(pickUpGeoPoint.latitude);
                                print(pickUpGeoPoint.latitude);

                                // print(pickAdd.contains('-------------------------'));
                                // print(pickAdd.contains('Rawalpindi'));
                                // print(pickAdd.contains('Islamabad'));
                                // print(pickAdd.contains('-------------------------'));

                                if  ((_dropLocation != null && _dropLocation.contains('Rawalpindi')) || _pickUpLocation.contains('Rawalpindi')){
                                  _deliveryChargesController.text = '300 PKR';
                                  deliveryCharges = 300;
                                }if (_pickUpLocation.contains('Islamabad')){
                                  _deliveryChargesController.text = '200 PKR';
                                  deliveryCharges = 200;
                                }
                              });
                            },
                            usePinPointingSearch: true,
                            desiredLocationAccuracy: LocationAccuracy.high,
                            initialPosition: LatLng(37.42796133580664, -122.085749655962),
                            useCurrentLocation: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TextFormField(
                  controller: _pickUpController,
                  maxLines: 3,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Pickup Address',
                    hintMaxLines: 3,
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String arg) {
                    if (arg.isEmpty)
                      return 'Please provide pickup address';
                    else {
                      return null;
                    }
                  },
                ),





                SizedBox(height: 10,),



                ListTile(
                  title: Text('Select Drop Location'),
                  trailing: IconButton(
                    icon: Icon(Icons.add,
                      color: isDisable ? Colors.white : Color(0xFFFEBC10),),
                    onPressed: isDisable ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: 'AIzaSyCN-2fyocInwIfJ5EZhLgiWpA9cOY2sWV8',   // Put YOUR OWN KEY here.
                            onPlacePicked: (result) {
                             Navigator.of(context).pop();
                              setState(() {

                                _dropController.text = result.formattedAddress;
                                print(result.addressComponents[3].longName); // job done, welldone
                                // print(result.addressComponents[3].longName);
                                String locality = result.addressComponents[4].longName;
                                print('checking the locality.contains(Islamabad)');
                                print(locality.contains('Islamabad'));
                                _dropLocation = locality;
                                Location dropLocation = result.geometry.location;
                                dropGeoPoint = new GeoPoint(dropLocation.lat, dropLocation.lng);

                                if  (_dropLocation.contains('Rawalpindi') || (_pickUpLocation != null && _pickUpLocation.contains('Rawalpindi'))){
                                  _deliveryChargesController.text = '300 PKR';
                                  deliveryCharges = 300;
                                }if (_pickUpLocation.contains('Islamabad')){
                                  _deliveryChargesController.text = '200 PKR';
                                  deliveryCharges = 200;
                                }

                              });
                            },
                            usePinPointingSearch: true,
                            desiredLocationAccuracy: LocationAccuracy.high,
                            initialPosition: LatLng(37.42796133580664, -122.085749655962),
                            useCurrentLocation: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TextFormField(
                  controller: _dropController,
                  maxLines: 3,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Drop Address',
                    hintMaxLines: 3,
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String arg) {
                    if (arg.isEmpty)
                      return 'Please provide drop address';
                    else {
                      return null;
                    }
                  },
                ),





                TextFormField(
                  controller: _deliveryChargesController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Delivery Charges',
                  ),
                  keyboardType: TextInputType.name,
                  validator: (String arg) {
                    if (arg.isEmpty)
                      return 'Delivery Charges';
                    else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  enabled: isDisable ? false : true,
                  decoration: InputDecoration(
                    labelText: 'Order Description',
                    hintMaxLines: 5,
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String arg) {
                  if (arg.isEmpty)
                    return 'Please fill the order description';
                  else {
                    return null;
                  }
                },
                ),
                SizedBox(height: 20,),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Express Delivery Services are available for Islamabad and Rawalpindi.'),
                // Text('Make sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
