import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHistory extends StatefulWidget {
  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {

  Widget _historyItem({String time, String price, String point, String point_des}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.black54,
          height: 30,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // TODO according to design
            children: [
              ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                  color: Color(0xFF29146F),
                ),
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Align(
                  alignment: Alignment(-1.4, 0),
                  child: Column(
                      children: [
                        Text(
                          point,
                          style: TextStyle(
                            color: Color(0xFF29146F),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          point_des,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                  color: Color(0xFFFEBC10),
                ),
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Align(
                  alignment: Alignment(-1.4, 0),
                  child: Column(
                    children: [
                      Text(
                        point,
                        style: TextStyle(
                          color: Color(0xFF29146F),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        point_des,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          color: Color(0xFF29146F),
        ),
        title: Text(
          'HISTORY',
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
          children: [
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
            _historyItem(time: 'YESTERDAY, 5:00PM', price: 'PKR 600', point: 'Ibn-e-sina Road', point_des: 'Near G12, Islamabad'),
          ],
        ),
      )
    );
  }
}
