import 'package:cloud_firestore/cloud_firestore.dart';

class RidersLocation{
  final GeoPoint geoPoint;
  final String riderDocID;
  final String id;

  RidersLocation({this.geoPoint,this.riderDocID, this.id});

  Map<String, dynamic> toMap() {
    return {
      "geoPoint": geoPoint,
      "riderDocID": riderDocID,
    };
  }

}