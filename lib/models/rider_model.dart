class RiderModel {
  final String id;

  final String fullName;
  final String email;

  final String phone;

  final String cnic;

  final String vehicleRegistrationNumber;
  final String address;

  final String authID;
  final String status;

  final DateTime timestamp;

  RiderModel(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.cnic,
      this.vehicleRegistrationNumber,
      this.address,
      this.authID,
      this.status,
      this.timestamp});

  RiderModel.fromMap(Map<String, dynamic> data, String id)
      : fullName = data['fullName'],
        email = data['email'],
        phone = data['phone'],
        cnic = data['cnic'],
        vehicleRegistrationNumber = data['vehicleRegistrationNumber'],
        address = data['address'],
        authID = data['authID'],
        status = data['status'],
        timestamp = data['timestamp'].toDate(),
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "cnic": cnic,
      "vehicleRegistrationNumber": vehicleRegistrationNumber,
      "address": address,
      "authID": authID,
      "status": status,
      "timestamp": timestamp,
    };
  }
}
