import 'customerModel.dart';

class DataItem {
 final String createdAt;
 final Customer customer;
  final String id;
  final int rating;
  final String review;

  DataItem({
    required this.createdAt,
    required this.customer,
    required this.id,
    required this.rating,
    required this.review});


  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      createdAt: json['createdAt'],
      customer: Customer.fromJson(json['customer']),
      id: json['id'],
      rating: json['rating'],
      review: json['review'],
    );
  }
}

class GetReviewsResponseModel{
  final String status;
  final int results;
  final List<DataItem> items;

  GetReviewsResponseModel ({
    required this.status,
    required this.results,
    required this.items,
  });

  factory GetReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data']['data'] as List<dynamic>;
    List<DataItem> items =
    dataList.map((item) => DataItem.fromJson(item)).toList();

    return GetReviewsResponseModel(
      status: json['status'],
      results: json['results'],
      items: items,
    );
  }
}

