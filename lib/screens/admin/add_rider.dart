import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/rider_model.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRider extends StatefulWidget {
  @override
  _AddRiderState createState() => _AddRiderState();
}

class _AddRiderState extends State<AddRider> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _cnic = new TextEditingController();
  TextEditingController _vehicleRegNum = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  FocusNode _emailNode = new FocusNode();
  FocusNode _phoneNode = new FocusNode();
  FocusNode _cnicNode = new FocusNode();
  FocusNode _vehicleRegNode = new FocusNode();
  FocusNode _addressNode = new FocusNode();

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_key.currentState.validate()) {
          try {
            await FirestoreService().addRider(RiderModel(
              fullName: _name.text,
              email: _email.text,
              phone: '+92${_phone.text}',
              cnic: _cnic.text,
              vehicleRegistrationNumber: _vehicleRegNum.text,
              address: _address.text,
              authID: '',
              status: 'free',
              timestamp: Timestamp.now().toDate(),
            ));
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
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'ADD RIDER',
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
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_phoneNode);
                  },
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  focusNode: _phoneNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_cnicNode);
                  },
                  controller: _phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefix: Text('+92'),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String arg) {
                    if (arg.length < 10)
                      return 'Enter Valid Phone Number';
                    else
                      return null;
                  },
                  onSaved: (String val) {
                    // _name = val;
                  },
                ),
                TextFormField(
                  focusNode: _cnicNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_vehicleRegNode);
                  },
                  controller: _cnic,
                  maxLength: 13,
                  decoration: InputDecoration(
                    labelText: 'CNIC',
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String arg) {
                    if (arg.length < 13)
                      return 'Enter Valid CNIC';
                    else
                      return null;
                  },
                ),
                TextFormField(
                  focusNode: _vehicleRegNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(_addressNode);
                  },
                  controller: _vehicleRegNum,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Registration Number',
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  focusNode: _addressNode,
                  controller: _address,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintMaxLines: 3,
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
