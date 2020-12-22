import 'package:express_delivery/models/rider_model.dart';
import 'package:express_delivery/screens/rider/rider_details.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiderList extends StatefulWidget {
  @override
  _RiderListState createState() => _RiderListState();
}

class _RiderListState extends State<RiderList> {
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
          'RIDERS',
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
      body: StreamBuilder(
          stream: FirestoreService().getRiders(),
          builder: (context, snapshot) {
            if (snapshot.hasError && !snapshot.hasData) {
              print(snapshot.error.toString());
              return Container(
                padding: EdgeInsets.all(
                  30,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.all(
                  30,
                ),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int) {
                    RiderModel riderModel = snapshot.data[int];
                    return ListTile(
                      leading: Icon(
                        Icons.motorcycle,
                        color: Color(0xFFFEBC10),
                      ),
                      title: Text(
                        riderModel.fullName,
                        style: TextStyle(
                          color: Color(0xFF29146F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        riderModel.phone,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiderDetails(
                                      riderModel: riderModel,
                                    )));
                      },
                    );
                  },
                ),
              );
            }
            return Container();
          }),
    );
  }
}
