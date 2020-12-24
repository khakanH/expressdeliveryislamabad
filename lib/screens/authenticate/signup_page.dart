import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/customer_model.dart';
import 'package:express_delivery/screens/customer/home_user.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  FocusNode _emailNode = new FocusNode();

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_key.currentState.validate()) {
          try {
            await FirestoreService().addCustomer(CustomerModel(
              fullName: _name.text,
              email: _email.text,
              phone: '${FirebaseAuth.instance.currentUser.phoneNumber}',
              timestamp: Timestamp.now().toDate(),
            ), '${FirebaseAuth.instance.currentUser.uid}');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserHome(fullName: _name.text,)),);
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
          'ADD',
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
        title: Text(
          'JUST FEW SECONDS WAY',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              padding: EdgeInsets.all(
                30,
              ),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Text(
                      'Please fill in few details below',
                      style: TextStyle(),
                    ),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: (){
                        FocusScope.of(context).requestFocus(_emailNode);
                      },
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String arg) {
                        if (arg.length < 3)
                          return 'Enter Valid Name';
                        else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      focusNode: _emailNode,
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
              ),
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }
}
