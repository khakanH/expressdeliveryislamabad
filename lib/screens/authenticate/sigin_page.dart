import 'package:express_delivery/screens/authenticate/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _controller = new TextEditingController();
  bool validate = false;

  // Widget _entryField(String title) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           title,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         TextField(
  //           maxLength: 10,
  //           decoration: InputDecoration(
  //               prefixText: '+92',
  //               border: InputBorder.none,
  //               fillColor: Color(0xfff3f3f4),
  //               filled: true),
  //           controller: _controller,
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (validate) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OtpPage(_controller.text,)));
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
          'VERIFY',
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
          icon: Icon(FontAwesomeIcons.longArrowAltLeft),
          color: Color(0xFF29146F),
        ),
        title: Text(
          'GET STARTED ',
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
      body: Container(
        padding: EdgeInsets.all(
          20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    maxLength: 10,
                    onChanged: (String value) {
                      if (value.length < 10) {
                        validate = false;
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
                        validate = true;
                        return null;
                      }
                    },
                    onSaved: (String val) {
                      // _name = val;
                    },
                  ),
                ],
              ),
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }
}
