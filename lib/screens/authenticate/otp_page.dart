import 'package:express_delivery/screens/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpPage extends StatefulWidget {
  final String phone;

  OtpPage(this.phone,);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _verification_code;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Verification code sent!',
              style: TextStyle(
                color: Color(0xFF29146F),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Enter the code we sent via SMS',
              style: TextStyle(
                color: Color(0xFF29146F),
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '+92 ${widget.phone}',
              style: TextStyle(
                color: Color(0xFF29146F),
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Code',
              style: TextStyle(
                color: Color(0xFF29146F),
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              child: PinPut(
                fieldsCount: 6,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verification_code, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        print('user logged in');
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Loading(
                        //               user_id: value.user.uid,
                        //               phone_number: '${widget.phone}',
                        //             )),
                        //     (route) => false);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                  }
                },
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                selectedFieldDecoration: _pinPutDecoration,
                followingFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.deepPurpleAccent.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+92${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print('user logged in');
            // value.user.phoneNumber
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Loading(
            //               user_id: value.user.uid,
            //               phone_number: value.user.phoneNumber,
            //             )),
            //     (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationID, int resendToken) {
        setState(() {
          _verification_code = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verification_code = verificationID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
