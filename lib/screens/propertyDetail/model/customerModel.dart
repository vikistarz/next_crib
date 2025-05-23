class Customer {
  final String firstName;
  final String lastName;
  final String id;

  Customer({
    required this.firstName,
    required this.lastName,
    required this.id,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
      id: json['id'].toString(),
    );
  }
}