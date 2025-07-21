class Customer {
  final String id;
  String name;
  String phoneNumber;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  // Convert to Database Model
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  // Create from Database
  factory Customer.fromDatabase(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
    );
  }
}