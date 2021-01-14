import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:express_delivery/models/working_time_model.dart';
import 'package:express_delivery/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WorkingTime extends StatefulWidget {
  @override
  _WorkingTimeState createState() => _WorkingTimeState();
}

class _WorkingTimeState extends State<WorkingTime> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _fromController = new TextEditingController();
  TextEditingController _toController = new TextEditingController();
  final format = DateFormat("HH:mm");

  String docId = '';

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_key.currentState.validate()) {
          // if (doc_id.isEmpty){
          //   try {
          //     await FirestoreService().addWorkingTime(WorkingTimeModel(
          //       from: _fromController.text,
          //       to: _toController.text
          //     ));
          //     setState(() {
          //
          //     });
          //   } catch (e) {
          //     print(e.toString());
          //   }
          // }
          // if (doc_id.isNotEmpty){
          try {
            await FirestoreService().updateWorkingTime(
                WorkingTimeModel(
                    from: _fromController.text, to: _toController.text),
                'working_time');
            setState(() {});
          } catch (e) {
            print(e.toString());
          }
          // }
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
          'UPDATE',
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
          'Working Time',
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
                Text(
                  'Please provide the details, when customers can place order.',
                  style: TextStyle(
                    color: Color(0xFF29146F),
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('From:'),
                DateTimeField(
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                  controller: _fromController,
                  autovalidate: true,
                  validator: (dateTime) {
                    if (dateTime.toString().isEmpty)
                      return 'Required';
                    else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('To:'),
                DateTimeField(
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                  controller: _toController,
                  autovalidate: true,
                  validator: (dateTime) {
                    if (dateTime.toString().isEmpty)
                      return 'Required';
                    else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                SizedBox(
                  height: 40,
                ),
                Card(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('working_time')
                        .get(),
                    builder: (context, querySnapshot) {
                      if (querySnapshot.hasError) {
                        print('error in future builder');
                      }
                      if (querySnapshot.hasData) {
                        if (querySnapshot.data.size > 0) {
                          // doc_id = querySnapshot.data.docs.first.id;
                          String currentTime =
                              ' Current working time is set from ${querySnapshot.data.docs.first.get('from')} to ${querySnapshot.data.docs.first.get('to')}';
                          return Container(
                            padding: EdgeInsets.all(
                              30,
                            ),
                            child: Center(
                              child: Text(
                                currentTime,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }
                      return Container(
                        padding: EdgeInsets.all(
                          30,
                        ),
                        child: Center(
                          child: Text(
                            'No working time set.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
