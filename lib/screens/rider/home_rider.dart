import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/drawer/rider_drawer.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/models/rider_model.dart';
import 'package:express_delivery/models/riders_loc_model.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RiderHome extends StatefulWidget {
  final String fullname;

  const RiderHome({Key key, this.fullname}) : super(key: key);

  @override
  _RiderHomeState createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> with WidgetsBindingObserver {
  Set<Marker> _markers = {};
  BitmapDescriptor pickUpMarker;
  BitmapDescriptor dropMarker;

  GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    setMarkers();
    print('-------------');
    print('initState');
    WidgetsBinding.instance.addObserver(this);
  }

  static final CameraPosition _kIslamabad = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 15,
  );

  static bool isStartButtonPressed = false;
  bool isCompleteButtonPressed = false;

  bool isRiderLocationDocExists = false;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void setMarkers() async {
    pickUpMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/pick.png');
    dropMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/drop.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RiderDrawer(
        fullName: widget.fullname,
      ),
      appBar: AppBar(
        title: Text(
          'Rider Home',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF29146F),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          customGoogleMap(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('riderPhoneNum',
                    isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
                .where('status', isEqualTo: 'assigned')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print('------------------------------------');
              print('inside stream builder');
              print('------------------------------------');
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData) {
                if (snapshot.data.size == 1) {
                  renderPoints(snapshot);
                  return DraggableScrollableSheet(
                    initialChildSize: 0.30,
                    minChildSize: 0.02,
                    maxChildSize: 0.6,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Card(
                          elevation: 12.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(
                                20,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      'YOUR CURRENT JOB',
                                      style: TextStyle(
                                        color: Color(0xFF29146F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      height: 20,
                                      thickness: 2,
                                      color: Colors.black54,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    ListTile(
                                      leading: Image.asset('assets/pick.png',
                                        width: 24,
                                        height: 24,),
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Align(
                                        alignment: Alignment(-1.4, 0),
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data.docs.first
                                                  .get('pickUpAddress'),
                                              style: TextStyle(
                                                color: Color(0xFF29146F),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Image.asset('assets/drop.png',
                                      width: 24,
                                      height: 24,),
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Align(
                                        alignment: Alignment(-1.4, 0),
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data.docs.first
                                                  .get('dropAddress'),
                                              style: TextStyle(
                                                color: Color(0xFF29146F),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 20,
                                      thickness: 2,
                                      color: Colors.black12,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Flexible(
                                            child: ListTile(
                                              title: Text('BOOKING DETAILS'),
                                              subtitle: Text(
                                                snapshot.data.docs.first
                                                    .get('description'),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: Colors.black38,
                                          ),
                                          Flexible(
                                            child: ListTile(
                                              title: Text('DELIVERY CHARGES'),
                                              subtitle: Text(
                                                  '${snapshot.data.docs.first.get('deliveryCharges')} PKR'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 20,
                                      thickness: 2,
                                      color: Colors.black12,
                                    ),
                                    Center(
                                      child: FlatButton(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              isStartButtonPressed
                                                  ? Icons.stop_circle
                                                  : Icons
                                                      .play_circle_filled_outlined,
                                            ),
                                            Text(
                                              isStartButtonPressed
                                                  ? 'JOB COMPLETED'
                                                  : 'START JOB',
                                              style: TextStyle(
                                                color: Color(0xFF29146F),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: isStartButtonPressed
                                            ? () {
                                                // TODO change the order status to complete
                                                setState(() {
                                                  isCompleteButtonPressed =
                                                      true;
                                                  updateRiderStatus('free');
                                                  completeOrder(snapshot);
                                                });
                                              }
                                            : () {
                                                setState(() {
                                                  isStartButtonPressed = true;
                                                  updateRiderStatus('busy');
                                                  broadcastRider(snapshot);
                                                });
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  print('------------------------------------');
                  print('no assigned order is in queue');
                  print('------------------------------------');
                }
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget customGoogleMap() {
    return Container(
      color: Colors.blue[50],
      child: GoogleMap(
        mapType: MapType.terrain,
        zoomControlsEnabled: false,
        initialCameraPosition: _kIslamabad,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }

  void broadcastRider(AsyncSnapshot<QuerySnapshot> snapshot) async {
    print('------------------------------------');
    print('inside broadcastRider');
    print('------------------------------------');
    print(isStartButtonPressed);
    print(isCompleteButtonPressed);
    if (isStartButtonPressed && !isCompleteButtonPressed) {
      // location.enableBackgroundMode(enable: true);
      print('------------------------------------');
      print('inside if isStartButtonPressed && !isCompleteButtonPressed');
      print('------------------------------------');
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      moveCamera(_locationData, snapshot);

      location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location
        moveCamera(currentLocation, snapshot);
      });
    }
  }

  void moveCamera(
      LocationData locationData, AsyncSnapshot<QuerySnapshot> snapshot) {
    print('------------------------------------');
    print('inside moveCamera');
    print('------------------------------------');
    updateRiderLocationOnFirestore(locationData, snapshot);
    CameraPosition newCameraPosition = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: 10,
    );
    _googleMapController
        .moveCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    print(locationData.latitude);
    print(locationData.longitude);
  }

  void updateRiderLocationOnFirestore(
      LocationData locationData, AsyncSnapshot<QuerySnapshot> snapshot) async {
    try {
      GeoPoint geoPoint =
          new GeoPoint(locationData.latitude, locationData.longitude);
      await FirestoreService().updateRiderLocation(
          RidersLocation(
            geoPoint: geoPoint,
            riderDocID: snapshot.data.docs.first.get('riderID'),
          ),
          FirebaseAuth.instance.currentUser.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  void completeOrder(AsyncSnapshot<QuerySnapshot> snapshot) async {
    print('------------------------------------');
    print('inside completeOrder');
    print('------------------------------------');
    try {
      await FirestoreService().updateOrder(
          OrderModel(
            customerID: snapshot.data.docs.first.get('customerID'),
            customerFullNname:
                snapshot.data.docs.first.get('customerFullNname'),
            customerPhoneNum: snapshot.data.docs.first.get('customerPhoneNum'),
            riderID: snapshot.data.docs.first.get('riderID'),
            riderFullName: snapshot.data.docs.first.get('riderFullName'),
            riderPhoneNum: snapshot.data.docs.first.get('riderPhoneNum'),
            deliveryCharges: snapshot.data.docs.first.get('deliveryCharges'),
            pickUpAddress: snapshot.data.docs.first.get('pickUpAddress'),
            dropAddress: snapshot.data.docs.first.get('dropAddress'),
            pickUpGeoPoint: snapshot.data.docs.first.get('pickUpGeoPoint'),
            droppGeoPoint: snapshot.data.docs.first.get('droppGeoPoint'),
            description: snapshot.data.docs.first.get('description'),
            status: 'complete',
            timestamp: snapshot.data.docs.first.get('timestamp').toDate(),
          ),
          snapshot.data.docs.first.id);
      // TODO notification on completion for respective customer
      setState(() {
        _markers = {};
        isStartButtonPressed = false;
        isCompleteButtonPressed = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  void renderPoints(AsyncSnapshot<QuerySnapshot> snapshot) {
    // setState(() {
    GeoPoint pickUp = snapshot.data.docs.first.get('pickUpGeoPoint');
    GeoPoint drop = snapshot.data.docs.first.get('droppGeoPoint');
    _markers.add(Marker(
      markerId: MarkerId('pickUpPoint'),
      position: LatLng(pickUp.latitude, pickUp.longitude),
      infoWindow: InfoWindow(title: 'PickUp Point'),
      icon: pickUpMarker,
    ));
    _markers.add(Marker(
      markerId: MarkerId('dropPoint'),
      position: LatLng(drop.latitude, drop.longitude),
      infoWindow: InfoWindow(title: 'Drop Point'),
      icon: dropMarker,
    ));
    // });
  }

  void updateRiderStatus(String status) {
    FirebaseFirestore.instance
        .collection('riders')
        .where('phone',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((querySnaphot) async {
      if (querySnaphot.size == 1 && querySnaphot.docs.first.exists) {
        try {
          print('------------------------------------');
          print('inside updateRiderModel');
          await FirestoreService().updateRider(
              RiderModel(
                fullName: querySnaphot.docs.first.get('fullName'),
                email: querySnaphot.docs.first.get('email'),
                phone: querySnaphot.docs.first.get('phone'),
                cnic: querySnaphot.docs.first.get('cnic'),
                vehicleRegistrationNumber:
                    querySnaphot.docs.first.get('vehicleRegistrationNumber'),
                address: querySnaphot.docs.first.get('address'),
                authID: FirebaseAuth.instance.currentUser.uid,
                status: status,
                timestamp: querySnaphot.docs.first.get('timestamp').toDate(),
              ),
              querySnaphot.docs.first.id);
        } catch (e) {
          print('------------------------------------');
          print('-------rider home error----------');
          print(e.toString());
          print('------------------------------------');
        }
      }
    });
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('-------------');
    print('dispose');
    super.dispose();
  }

  void startNewAssignedOrderService() async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.vconekt.express_delivery");
      String data = await methodChannel.invokeMethod("startNewAssignedOrderService");
      debugPrint(data);
    }
  }

  void stopAssignedOrderService() async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.vconekt.express_delivery");
      String data = await methodChannel.invokeMethod("stopAssignedOrderService");
      debugPrint(data);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    print('-------------');
    print('state = $state');

    if (state == AppLifecycleState.paused){
      startNewAssignedOrderService();
    }
    if (state == AppLifecycleState.resumed){
      stopAssignedOrderService();
    }

  }
}
