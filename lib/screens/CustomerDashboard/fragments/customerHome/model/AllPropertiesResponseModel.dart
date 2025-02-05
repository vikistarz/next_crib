


class Agent {
  final String id;
  final String firstName;
  final String lastName;

  Agent({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'].toString(),
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
    );
  }
}


class DataItem {
  final double ratingsAverage;
  final int ratingsQuantity;
  final List<String> propertyImages;
  final List<double> coordinates;
  final String createdAt;
  final String ids;
  final String title;
  final int stock;
  final int dimension;
  final int annualCost;
  final int totalPackage;
  final String description;
  final String category;
  final int bedroom;
  final int toilets;
  final Agent agent;
  final String state;
  final String city;
  final String location;
  final String sku;
  final String id;

  DataItem({
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.propertyImages,
    required this.coordinates,
    required this.createdAt,
    required this.ids,
    required this.title,
    required this.stock,
    required this.dimension,
    required this.annualCost,
    required this.totalPackage,
    required this.description,
    required this.category,
    required this.bedroom,
    required this.toilets,
    required this.agent,
    required this.state,
    required this.city,
    required this.location,
    required this.sku,
    required this.id});


  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      ratingsAverage: (json['ratingsAverage'] as num).toDouble(),
      ratingsQuantity: (json['ratingsQuantity']) ?? 0,
      propertyImages: List<String>.from(json['propertyImages']),
      coordinates: List<double>.from(json['coordinates']),
      createdAt: json['createdAt'],
      ids: json['_id'],
      title: json['title'],
      stock: json['stock'],
      dimension: json['dimension'],
      annualCost: json['annualCost'],
      totalPackage: json['totalPackage'],
      description: json['description'],
      category: json['category'],
      bedroom: json['bedrooms'],
      toilets: json['toilets'],
      agent: Agent.fromJson(json['agent']),
      state: json['state'],
      city: json['city'],
      location: json['location'],
      sku: json['sku'],
      id: json['id'],
    );
  }
}

class AllPropertiesResponseModel {
  final String status;
  final int results;
  final List<DataItem> items;

  AllPropertiesResponseModel({
    required this.status,
    required this.results,
    required this.items,
  });

  factory AllPropertiesResponseModel .fromJson(Map<String, dynamic> json) {
    final dataList = json['data']['data'] as List<dynamic>;
    List<DataItem> items =
    dataList.map((item) => DataItem.fromJson(item)).toList();

    return AllPropertiesResponseModel (
      status: json['status'],
      results: json['results'],
      items: items,
    );
  }
}


// // class AllPropertiesResponseModel {
// //   final double ratingsAverage;
// //   final int ratingsQuantity;
// //   final List<String> propertyImages;
// //   final List<double> coordinates;
// //   final String createdAt;
// //   final String ids;
// //   final String title;
// //   final int stock;
// //   final String dimension;
// //   final int annualCost;
// //   final int totalPackage;
// //   final String description;
// //   final String category;
// //   final int bedroom;
// //   final int toilets;
// //   final String agent;
// //   final String state;
// //   final String city;
// //   final String location;
// //   final String sku;
// //   final String id;
//
//   // AllPropertiesResponseModel(
//   //     {required this.ratingsAverage,
//   //     required this.ratingsQuantity,
//   //     required this.propertyImages,
//   //     required this.coordinates,
//   //     required this.createdAt,
//   //     required this.ids,
//   //     required this.title,
//   //     required this.stock,
//   //     required this.dimension,
//   //     required this.annualCost,
//   //     required this.totalPackage,
//   //     required this.description,
//   //     required this.category,
//   //     required this.bedroom,
//   //     required this.toilets,
//   //     required this.agent,
//   //     required this.state,
//   //     required this.city,
//   //     required this.location,
//   //     required this.sku,
//   //     required this.id});
//
//
//   factory DataItem{required city}{required city}.fromJson(Map<String, dynamic> json) {
//     return DataItem(
//       ratingsQuantity: json['ratingsQuantity'],
//       coordinates: List<double>.from(json['coordinates']
//           .map((x) => (x is int) ? x.toDouble() : x)),
//       createdAt: DateTime.parse(json['createdAt']),
//       agent: Agent.fromJson(json['agent']),
//       state: json['state'],
//       city: json['city'],
//     );
//   }
// }
//
//   // Factory constructor for JSON deserialization
//   factory AllPropertiesResponseModel.fromJson(Map<String, dynamic> json) {
//     return AllPropertiesResponseModel(
//       ratingsAverage: (json['ratingsAverage'] as num).toDouble(),
//       ratingsQuantity: (json['ratingsQuantity']) ?? 0,
//       propertyImages: List<String>.from(json['propertyImages']),
//       coordinates: List<double>.from(json['coordinates']),
//       createdAt: json['createdAt'],
//       ids: json['_id'],
//       title: json['title'],
//       stock: json['stock'],
//       dimension: json['dimension'],
//       annualCost: json['annualCost'],
//       totalPackage: json['totalPackage'],
//       description: json['description'],
//       category: json['category'],
//       bedroom: json['bedrooms'],
//       toilets: json['toilets'],
//       agent: json['agent'],
//       state: json['state'],
//       city: json['city'],
//       location: json['location'],
//       sku: json['sku'],
//       id: json['id'],
//     );
//   }
// }
