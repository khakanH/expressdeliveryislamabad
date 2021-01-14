import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/screens/admin/order_details.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Orders extends StatefulWidget {
  final String orderStatus;

  Orders({@required this.orderStatus});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    bool orderStatus = true;
    if ('${widget.orderStatus}' != 'complete') orderStatus = false;
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
          'ORDERS',
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
      body: StreamBuilder<List<OrderModel>>(
          stream:
          FirestoreService().getOrders(status: '${widget.orderStatus}'),
          builder: (context,snapshot) {
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
            if (snapshot.hasData){
              return Container(
                padding: EdgeInsets.all(
                  30,
                ),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int) {
                    OrderModel orderModel = snapshot.data[int];
                    return ListTile(
                      leading: orderStatus
                          ? Icon(
                        Icons.done,
                        color: Color(0xFFFEBC10),
                      )
                          : Icon(
                        Icons.cancel,
                        color: Color(0xFFFEBC10),
                      ),
                      title: Text(
                        orderModel.customerFullNname,
                        style: TextStyle(
                          color: Color(0xFF29146F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Description: ${orderModel.description}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => OrderDetails(orderModel: orderModel)));
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
