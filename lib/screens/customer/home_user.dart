import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/drawer/user_drawer.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/screens/customer/place_order.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget {
  final String fullName;

  final String title;
  final String pickUpAdd;
  final String dropAdd;
  final String desAdd;
  final String chargesAdd;

  const UserHome(
      {Key key,
      this.fullName,
      this.title,
      this.pickUpAdd,
      this.dropAdd,
      this.desAdd,
      this.chargesAdd})
      : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // Completer<GoogleMapController> _controller = Completer();

  GoogleMapController _googleMapController;
  PermissionStatus _permissionStatus;

  Set<Marker> _markers = Set();

  BitmapDescriptor _riderMarker;

  void setMarkers() async {
    print('rider marker');
    _riderMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/rider.png');
    // dropMarker = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(), 'assets/drop.png');
  }

  static final CameraPosition _kIslamabad = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    setMarkers();
  }

  bool _dragger = false;

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceOrder(
                      fullName: '${widget.fullName}',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(
          10,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF29146F), Color(0xFFFEBC10) ])),
        child: Center(
          child: Text(
            'Place Order',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Home',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        leading: null,
        centerTitle: true,
        backgroundColor: Color(0xFF29146F),
        elevation: 0,
      ),
      endDrawer: UserDrawer(
        fullName: '${widget.fullName}',
      ),
      body: Stack(
        children: <Widget>[
          CustomGoogleMap(),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('customerID',
                    isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .where('status', whereIn: ['pending', 'assigned']).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print('------------------------------------');
              print('inside stream builder');
              print('------------------------------------');
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData) {
                print('-------------------');
                print(FirebaseAuth.instance.currentUser.uid);
                print(snapshot.data.size);
                if (snapshot.data.size > 0) {
                  if (snapshot.data.docs.first.get('status') == 'pending') {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.30,
                      minChildSize: 0.15,
                      maxChildSize: 0.5,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: pendingScrollViewContent(snapshot),
                        );
                      },
                    );
                  }
                  if (snapshot.data.docs.first.get('status') == 'assigned') {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('riders_location')
                            .doc(snapshot.data.docs.first.get('riderID'))
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
                          if (documentSnapshot.hasData && documentSnapshot.data.exists) {
                            print('------------------------------------');
                            print(documentSnapshot.data.get('riderDocID'));

                            GeoPoint current =
                                documentSnapshot.data.get('geoPoint');

                            print('location change');
                            print(current.latitude);
                            print(current.longitude);
                            print('------------------------------------');
                            // Create a new marker
                            Marker resultMarker = Marker(
                              markerId: MarkerId('rider_location'),
                              infoWindow: InfoWindow(
                                title: 'Your Rider',
                              ),
                              position:
                                  LatLng(current.latitude, current.longitude),
                              icon: _riderMarker,
                            );

                            _markers.add(resultMarker);
                            _googleMapController.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(current.latitude, current.longitude),
                              zoom: 15,
                            )));
                            return DraggableScrollableSheet(
                              initialChildSize: 0.30,
                              minChildSize: 0.15,
                              maxChildSize: 0.5,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  child: assignedScrollViewContent(snapshot),
                                );
                              },
                            );
                          }
                          return Container();
                        });
                  }
                } else {
                  // setState(() {
                    _markers = {};
                  // });
                  print('------------------------------------');
                  print('no pending | assigned order in queue');
                  print('------------------------------------');
                }
              }

              return Container();
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('working_time')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData) {
                if (snapshot.data.size == 1) {
                  if (snapshot.data.docs.first
                          .get('from')
                          .toString()
                          .isNotEmpty &&
                      snapshot.data.docs.first
                          .get('to')
                          .toString()
                          .isNotEmpty) {
                    TimeOfDay now = TimeOfDay.now();
                    List fromString = snapshot.data.docs.first
                        .get('from')
                        .toString()
                        .split(":");
                    print(fromString.first);
                    print(fromString.last);
                    TimeOfDay fromTime = TimeOfDay(
                        hour: int.parse(fromString.first),
                        minute: int.parse(fromString.last));
                    List toString = snapshot.data.docs.first
                        .get('to')
                        .toString()
                        .split(":");
                    print(toString.first);
                    print(toString.last);
                    TimeOfDay toTime = TimeOfDay(
                        hour: int.parse(toString.first),
                        minute: int.parse(toString.last));

                    double _doubleNowTime =
                        now.hour.toDouble() + (now.minute.toDouble() / 60);
                    double _doubleFormTime = fromTime.hour.toDouble() +
                        (fromTime.minute.toDouble() / 60);
                    double _doubleToTime = toTime.hour.toDouble() +
                        (toTime.minute.toDouble() / 60);
                    if (_doubleNowTime > _doubleFormTime &&
                        _doubleNowTime < _doubleToTime) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('customerID',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser.uid)
                              .where('status',
                                  whereIn: ['pending', 'assigned']).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.hasData) {
                              print('-------------------');
                              print(FirebaseAuth.instance.currentUser.uid);
                              print(snapshot.data.size);
                              if (snapshot.data.size > 0) {
                                print(
                                    'cannot place order, as customer already have an order in queue');
                              } else {
                                print('------------------------------------');
                                print('no pending | assigned order in queue');
                                print('------------------------------------');
                                return Positioned(
                                    bottom: 10,
                                    right: 10,
                                    left: 10,
                                    child: _submitButton());
                              }
                            }

                            return Container();
                          });
                    } else {
                      String fromString = formatTimeOfDay(fromTime);
                      String toString = formatTimeOfDay(toTime);
                      return Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(
                              30,
                            ),
                            child: Center(
                              child: Text(
                                'Express Delivery provide services between $fromString to $toString.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                } else {
                  print('working time error, more than one document found');
                  return Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(
                          30,
                        ),
                        child: Center(
                          child: Text(
                            'Express Delivery working time not set.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }

              return Container();
            },
          )
        ],
      ),
    );
  }

  void checkLocationPermission() async {
    var _locationStatus = await perm.Permission.location.status;
    print(_locationStatus);

    if (!_locationStatus.isGranted) await perm.Permission.location.request();

    if (await perm.Permission.location.isGranted) {
      _permissionStatus = PermissionStatus.granted;
      print('permission-granted');
      // Location current = Location.instance.getLocation() as Location;
      // current.onLocationChanged.listen((LocationData currentLocation) {
      //   var kGooglePlex = CameraPosition(
      //     target: LatLng(current., -122.085749655962),
      //     zoom: 16,
      //   );
      // });
    } else {
      print('else-part');
      perm.openAppSettings();
    }
  }

  // Google Map in the background

  Widget CustomGoogleMap() {
    return Container(
      color: Colors.blue[50],
      child: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: _kIslamabad,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          // _controller.complete(controller);
        },
        onCameraMove: (cameraPosition) {
          print('--------------------------');
          print('onCameraMoveStarted');
          setState(() {
            _markers = _markers;
          });
        },
        onCameraMoveStarted: () {
          print('--------------------------');
          print('onCameraMoveStarted');
        },
        markers: _markers,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Widget pendingScrollViewContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    print('inside pendingScrollViewContent;');

    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  'FINDING YOUR RIDER!',
                  style: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Align(
                    alignment: Alignment(-1.4, 0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data.docs.first.get('pickUpAddress'),
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
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Align(
                    alignment: Alignment(-1.4, 0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data.docs.first.get('dropAddress'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text('BOOKING DETAILS'),
                          subtitle: Text(
                            snapshot.data.docs.first.get('description'),
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
                ListTile(
                  onTap: () {
                    _showMyDialog(snapshot);
                  },
                  leading: Icon(
                    Icons.cancel,
                    color: Color(0xFFFEBC10),
                    size: 20,
                  ),
                  title: Text(
                    'CANCEL RIDE',
                    style: TextStyle(
                      color: Color(0xFF29146F),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget assignedScrollViewContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    print('inside assignedScrollViewContent;');

    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  'YOUR RIDER IS ON THE WAY',
                  style: TextStyle(
                    color: Color(0xFF29146F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.grey[400],
                    size: 50,
                  ),
                  title: Text(snapshot.data.docs.first.get('riderFullName')),
                  subtitle: Text('+92-3171909272'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () async {
                          launch("tel://+923171909272");
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () async {
                          launch("sms:+923171909272");
                        },
                      ),
                    ],
                  ),
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
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Align(
                    alignment: Alignment(-1.4, 0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data.docs.first.get('pickUpAddress'),
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
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Align(
                    alignment: Alignment(-1.4, 0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data.docs.first.get('dropAddress'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text('BOOKING DETAILS'),
                          subtitle: Text(
                            snapshot.data.docs.first.get('description'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(AsyncSnapshot<QuerySnapshot> snapshot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This operation cannot role back.'),
                // Text('Make sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                confirmOrderCancel(snapshot);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void confirmOrderCancel(AsyncSnapshot<QuerySnapshot> snapshot) async {
    print('cancel order confirmed');
    print(snapshot.data.docs.first.id);
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
            status: 'canceled',
            timestamp: snapshot.data.docs.first.get('timestamp').toDate(),
            // timestamp: Timestamp.now().toDate(),
          ),
          snapshot.data.docs.first.id);
    } catch (e) {
      print(e.toString());
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }
}

// TODO next time use different aproch to handle the rider marker
