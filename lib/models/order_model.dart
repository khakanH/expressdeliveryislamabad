class OrderModel {
  final String id;

  final String customerID;
  final String customerFullNname;
  final String riderID;
  final String riderFullName;
  final String dropLocation;
  final int deliveryCharges;
  final String pickUpAddress;
  final String dropAddress;
  final String description;
  final String status;
  final DateTime timestamp;

  // pick and drop coordinates

  OrderModel(
      {this.id,
      this.customerID,
      this.customerFullNname,
      this.riderID,
      this.riderFullName,
      this.dropLocation,
      this.deliveryCharges,
      this.pickUpAddress,
      this.dropAddress,
      this.description,
      this.status,
      this.timestamp});

  OrderModel.fromMap(Map<String, dynamic> data, String id)
      : customerID = data['customerID'],
        customerFullNname = data['customerFullNname'],
        riderID = data['riderID'],
        riderFullName = data['riderFullName'],
        dropLocation = data['dropLocation'],
        deliveryCharges = data['deliveryCharges'],
        pickUpAddress = data['pickUpAddress'],
        dropAddress = data['dropAddress'],
        description = data['description'],
        status = data['status'],
        timestamp = data['timestamp'].toDate(),
        id = id;
}
