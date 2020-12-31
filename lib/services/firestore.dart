import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:express_delivery/models/customer_model.dart';
import 'package:express_delivery/models/order_model.dart';
import 'package:express_delivery/models/rider_model.dart';
import 'package:express_delivery/models/riders_loc_model.dart';
import 'package:express_delivery/models/working_time_model.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<OrderModel>> getOrders({@required String status}) {
    return _db
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => OrderModel.fromMap(doc.data(), doc.id),
          ).toList(),
        );
  }

  Stream<List<RiderModel>> getRiders() {
    return _db
        .collection('riders')
        .orderBy('fullName', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => RiderModel.fromMap(doc.data(), doc.id),
      ).toList(),
    );
  }

  Future<void> addRider(RiderModel riderModel){
    return _db.collection('riders').add(riderModel.toMap());
  }
  Future<void> updateRider(RiderModel riderModel, String id){
    return _db.collection('riders').doc(id).update(riderModel.toMap());
  }
  Future<void> updateOrder(OrderModel orderModel, String id){
    return _db.collection('orders').doc(id).update(orderModel.toMap());
  }

  Future<void> addOrder(OrderModel orderModel){
    return _db.collection('orders').add(orderModel.toMap());
  }

  Future<void> addCustomer(CustomerModel customerModel, String id){
    return _db.collection('customers').doc(id).set(customerModel.toMap());
  }

  Future<void> updateRiderLocation(RidersLocation ridersLocation,String id) async{
    return _db.collection('riders_location').doc(id).set(ridersLocation.toMap());
  }

  Future<void> addWorkingTime(WorkingTimeModel workingTimeModel){
    return _db.collection('working_time').add(workingTimeModel.toMap());
  }

  Future<void> updateWorkingTime(WorkingTimeModel workingTimeModel, String id){
    return _db.collection('working_time').doc(id).set(workingTimeModel.toMap());
  }
}
