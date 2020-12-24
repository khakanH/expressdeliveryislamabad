import 'package:express_delivery/models/rider_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiderDetails extends StatelessWidget {
  final RiderModel riderModel;

  const RiderDetails({Key key, this.riderModel}) : super(key: key);

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
          'RIDER DETAILS',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                enabled: false,
                initialValue: riderModel.fullName,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                enabled: false,
                initialValue: riderModel.email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: riderModel.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefix: Text('+92'),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                enabled: false,
                initialValue: riderModel.cnic,
                decoration: InputDecoration(
                  labelText: 'CNIC',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false,
                initialValue: riderModel.vehicleRegistrationNumber,
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration Number',
                ),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                enabled: false,
                initialValue: riderModel.address,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: riderModel.timestamp.toString(),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Registered DateTime',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
