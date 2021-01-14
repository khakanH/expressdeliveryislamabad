import 'package:express_delivery/screens/get_in_page.dart';
import 'package:express_delivery/screens/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          print('snapshot');
          print(snapshot);
          if (snapshot.hasData && snapshot != null) {
            // snapshot.data.uid
            return Loading();
          }
          return GetInPage();
        });
  }
}
