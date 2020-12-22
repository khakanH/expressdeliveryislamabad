class RiderModel {
  final String id;

  final String fullName;
  final String email;

  final String phone;

  final String cnic;

  final String vehicleRegistrationNumber;
  final String address;

  final DateTime timestamp;

  // TODO coordinates

  RiderModel(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.cnic,
      this.vehicleRegistrationNumber,
      this.address,
      this.timestamp});

  RiderModel.fromMap(Map<String, dynamic> data, String id) :
        fullName = data['fullName'],
        email = data['email'],
        phone = data['phone'],
        cnic = data['cnic'],
        vehicleRegistrationNumber = data['vehicleRegistrationNumber'],
        address = data['Address'],
        timestamp = data['timestamp'].toDate(),
        id = id;
}
