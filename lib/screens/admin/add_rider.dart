import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRider extends StatefulWidget {
  @override
  _AddRiderState createState() => _AddRiderState();
}

class _AddRiderState extends State<AddRider> {

  Widget _submitButton() {
    return InkWell(
      // onTap: () {
      //   if (validate) {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 OtpPage(_controller.text, user_type: _user_type)));
      //   }
      // },
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
        padding: EdgeInsets.all(30,),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                // controller: _controller,
                onChanged: (String value) {
                  if (value.length < 10) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 10)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              TextFormField(
                // controller: _controller,
                onChanged: (String value) {
                  if (value.length < 10) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 10)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              TextFormField(
                // controller: _controller,
                maxLength: 10,
                onChanged: (String value) {
                  if (value.length < 10) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefix: Text('+92'),
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 10)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              TextFormField(
                // controller: _controller,
                maxLength: 13,
                onChanged: (String value) {
                  if (value.length < 13) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'CNIC',
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 13)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              TextFormField(
                // controller: _controller,
                onChanged: (String value) {
                  if (value.length < 13) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration Number',
                ),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 13)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              TextFormField(
                // controller: _controller,
                onChanged: (String value) {
                  if (value.length < 13) {
                    // validate = false;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.streetAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String arg) {
                  if (arg.length < 13)
                    return 'Enter Valid Phone Number';
                  else {
                    // validate = true;
                    return null;
                  }
                },
                onSaved: (String val) {
                  // _name = val;
                },
              ),
              SizedBox(height: 20,),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
