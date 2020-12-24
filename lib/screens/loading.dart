import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/screens/admin/home_admin.dart';
import 'package:express_delivery/screens/authenticate/signup_page.dart';
import 'package:express_delivery/screens/customer/home_user.dart';
import 'package:express_delivery/screens/rider/home_rider.dart';
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
    isAdmin();
  }

  isAdmin() {
    print('inside async function');
    print('${FirebaseAuth.instance.currentUser.phoneNumber}');
    print('${FirebaseAuth.instance.currentUser.uid}');

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
        Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminHome(fullName: doc.get('fullName'),)),);
      } else {
        print('admin doc not exits');
        print(doc.exists);
        print(doc.data());
        checkForRider();
      }
    });
  }

  void checkForRider() {
    print('inside checkForRider');
    FirebaseFirestore.instance
        .collection('riders')
        .where('phone',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((querySnaphot) {
          if(querySnaphot.size == 1 && querySnaphot.docs.first.exists){
            print('rider doc exits');
            print('navigating to rider home screen');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RiderHome()),);
          }else{
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
                builder: (context) => UserHome(fullName: doc.get('fullName'),)),);
      } else {
        print('customer doc not exits');
        print('get new customer data');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpPage()),);
      }
    });
  }
}
