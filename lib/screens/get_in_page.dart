
import 'package:express_delivery/screens/authenticate/sigin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF29146F),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/bike-dark.png',
                  width: MediaQuery.of(context).size.width * .7,
                  height: MediaQuery.of(context).size.width * .7,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .7,
                  padding: EdgeInsets.symmetric(vertical: 10.0,),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color(0xFFFEBC10)),
                  child: Column(
                    children: [
                      Text(
                        'GET IN',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),

                      ),
                      Icon(
                        FontAwesomeIcons.longArrowAltRight,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/logo-white.png',
                  width: MediaQuery.of(context).size.width * .8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
