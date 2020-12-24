class OrderModel {
  final String id;

  final String customerID;
  final String customerFullNname;
  final String customerPhoneNum;
  final String riderID;
  final String riderFullName;
  final String riderPhoneNum;
  final String dropLocation;
  final int deliveryCharges;
  final String pickUpAddress;
  final String dropAddress;
  final String description;
  final String status;
  final DateTime timestamp;

  // TODO you can add rider assigned at

  // TODO pick and drop coordinates

  OrderModel(
      {this.id,
      this.customerID,
      this.customerFullNname,
      this.customerPhoneNum,
      this.riderID,
      this.riderFullName,
      this.riderPhoneNum,
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
        customerPhoneNum = data['customerPhoneNum'],
        riderID = data['riderID'],
        riderFullName = data['riderFullName'],
        riderPhoneNum = data['riderPhoneNum'],
        dropLocation = data['dropLocation'],
        deliveryCharges = data['deliveryCharges'],
        pickUpAddress = data['pickUpAddress'],
        dropAddress = data['dropAddress'],
        description = data['description'],
        status = data['status'],
        timestamp = data['timestamp'].toDate(),
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "customerID" : customerID,
      "customerFullNname" : customerFullNname,
      "customerPhoneNum" : customerPhoneNum,
      "riderID" : riderID,
      "riderFullName" : riderFullName,
      "riderPhoneNum" : riderPhoneNum,
      "dropLocation" : dropLocation,
      "deliveryCharges" : deliveryCharges,
      "pickUpAddress" : pickUpAddress,
      "dropAddress" : dropAddress,
      "description" : description,
      "status" : status,
      "timestamp" : timestamp,
    };
  }
}
