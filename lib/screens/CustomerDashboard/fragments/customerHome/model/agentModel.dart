class Agent {
  final bool isVerified;
  final double ratingsAverage;
  final int ratingsQuantity;
  final String id;
  final String firstName;
  final String lastName;

  Agent({
    required this.isVerified,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      isVerified: (json['isVerified']),
      ratingsAverage: (json['ratingsAverage'] as num).toDouble(),
      ratingsQuantity: (json['ratingsQuantity']) ?? 0,
      id: json['id'].toString(),
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
    );
  }
}