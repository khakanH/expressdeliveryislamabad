import 'package:express_delivery/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel orderModel;

  const OrderDetails({Key key, @required this.orderModel}) : super(key: key);

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
          'ORDER DETAIL',
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
              // customer data
              TextFormField(
                initialValue: orderModel.customerFullNname,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Customer Full Name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                initialValue: orderModel.customerPhoneNum,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              // rider data
              TextFormField(
                initialValue: orderModel.riderFullName,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Rider Full Name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                initialValue: orderModel.riderPhoneNum,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Rider Phone Number',
                  prefix: Text('+92'),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: '${orderModel.deliveryCharges} PKR',
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Delivery Charges',
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: 20,
              ),
              // pick and drop data
              TextFormField(
                initialValue: orderModel.pickUpAddress,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Pick Up Address',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                initialValue: orderModel.dropAddress,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Drop Address',
                ),
                keyboardType: TextInputType.name,
              ),

              // Order description
              TextFormField(
                initialValue: orderModel.description,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Oder Description',
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              // order status
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: orderModel.status,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Status',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: orderModel.timestamp.toString(),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'DateTime',
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
