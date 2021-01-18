import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/rider_model.dart';
import 'package:express_delivery/screens/admin/home_admin.dart';
import 'package:express_delivery/screens/authenticate/signup_page.dart';
import 'package:express_delivery/screens/customer/home_user.dart';
import 'package:express_delivery/screens/rider/home_rider.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool noAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF29146F),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bike.jpeg',
              ),
              SpinKitPulse(
                color: Colors.white,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // FirebaseCrashlytics.instance.crash();
    isAdmin();
  }

  isAdmin() {
    print('inside async function');
    print('${FirebaseAuth.instance.currentUser.phoneNumber}');
    print('${FirebaseAuth.instance.currentUser.uid}');

    try{
      FirebaseFirestore.instance
          .collection('admins')
          .doc('${FirebaseAuth.instance.currentUser.uid}')
          .get()
          .then((doc) {
        if (doc.exists) {
          print('admin doc exits');
          print('navigating to admin home screen');
          print(doc.exists);
          print(doc.data());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHome(
                    fullName: doc.get('fullName'),
                  )),
                  (route) => false);
        } else {
          print('admin doc not exits');
          print(doc.exists);
          print(doc.data());
          checkForRider();
        }
      });
    }catch(e){
      // todo
    }

  }

  void checkForRider() async {
    print('inside checkForRider');
    FirebaseFirestore.instance
        .collection('riders')
        .where('phone',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((querySnaphot) async {
      if (querySnaphot.size == 1 && querySnaphot.docs.first.exists) {
        print('rider doc exits');
        print('navigating to rider home screen');
        try {
          print('------------------------------------');
          print('inside updateRiderModel');
          // print(querySnaphot.docs.first.id);
          // print(querySnaphot.docs.first.get('fullName'));
          // print(querySnaphot.docs.first.get('email'));
          // print(querySnaphot.docs.first.get('cnic'));
          // print(querySnaphot.docs.first.get('vehicleRegistrationNumber'));
          // print(querySnaphot.docs.first.get('address'));
          // print(FirebaseAuth.instance.currentUser.uid);
          // print(querySnaphot.docs.first.get('timestamp'));
          // print('------------------------------------');
          if (querySnaphot.docs.first.get('authID') == '') {
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
                  status: querySnaphot.docs.first.get('status'),
                  timestamp: querySnaphot.docs.first.get('timestamp').toDate(),
                ),
                querySnaphot.docs.first.id);
          }
        } catch (e) {
          print('------------------------------------');
          print('-------error----------');
          print(e.toString());
          print('------------------------------------');
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => RiderHome(
                      fullname: querySnaphot.docs.first.get('fullName'),
                    )),
            (route) => false);
      } else {
        print('rider doc not exits');
        checkForCustomer();
      }
    });
  }

  void checkForCustomer() {
    print('inside checkForCustomer');
    FirebaseFirestore.instance
        .collection('customers')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .get()
        .then((doc) {
      if (doc.exists) {
        print('customer doc exits');
        print('navigating to customer home screen');
        print(doc.exists);
        print(doc.data());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHome(
                    fullName: doc.get('fullName'),
                  )),
        );
      } else {
        print('customer doc not exits');
        print('get new customer data');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
            (route) => false);
      }
    });
  }
}
