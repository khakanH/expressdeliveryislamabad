class CustomerModel {
  final String fullName;
  final String email;
  final String phone;
  final String id;
  final DateTime timestamp;

  CustomerModel(
      {this.fullName, this.email, this.phone, this.id, this.timestamp});

  CustomerModel.fromMap(Map<String, dynamic> data, String id)
      : fullName = data['fullName'],
        email = data['email'],
        phone = data['phone'],
        timestamp = data['timestamp'].toDate(),
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "timestamp": timestamp,
    };
  }
}
