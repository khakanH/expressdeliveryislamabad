import 'dart:async';
import 'package:express_delivery/drawer/user_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _googleMapController;

  PermissionStatus _permissionStatus;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: UserDrawer(),
      body: Stack(
        children: <Widget>[
          CustomGoogleMap(),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.15,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: CustomScrollViewContent(),
              );
            },
          ),
        ],
      ),
    );
  }

  void checkLocationPermission() async {
    var _locationStatus = await Permission.location.status;
    print(_locationStatus);

    if (!_locationStatus.isGranted) await Permission.location.request();

    if (await Permission.location.isGranted) {
      _permissionStatus = PermissionStatus.granted;
      print('permission-granted');
    }else{
      print('else-part');
      openAppSettings();
    }

  }

  // Google Map in the background

  Widget CustomGoogleMap() {
    return Container(
      color: Colors.blue[50],
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          // _controller.complete(controller);
        },
      ),
    );
  }

  Widget CustomScrollViewContent() {
    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: CustomInnerContent(),
      ),
    );
  }

  Widget CustomInnerContent() {
    return Column(
      children: <Widget>[
        Text('$_permissionStatus'),
      ],
    );
  }
}
