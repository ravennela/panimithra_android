import 'dart:convert';

// ✅ Safe JSON parsing
FetchReviewsModel fetchReviewsModelFromJson(String str) =>
    FetchReviewsModel.fromJson(json.decode(str));

String fetchReviewsModelToJson(FetchReviewsModel data) =>
    json.encode(data.toJson());

class FetchReviewsModel {
  final int totalItems;
  final List<ReviewsItem> data;
  final int totalPages;
  final int pageSize;
  final int currentPage;

  FetchReviewsModel({
    required this.totalItems,
    required this.data,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
  });

  factory FetchReviewsModel.fromJson(Map<String, dynamic> json) {
    return FetchReviewsModel(
      totalItems: (json['totalItems'] is int)
          ? json['totalItems']
          : int.tryParse(json['totalItems']?.toString() ?? '0') ?? 0,
      data: (json['data'] is List)
          ? List<ReviewsItem>.from(
              (json['data'] as List)
                  .map((x) => ReviewsItem.fromJson(x))
                  .whereType<ReviewsItem>(),
            )
          : <ReviewsItem>[],
      totalPages: (json['totalPages'] is int)
          ? json['totalPages']
          : int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
      pageSize: (json['pageSize'] is int)
          ? json['pageSize']
          : int.tryParse(json['pageSize']?.toString() ?? '0') ?? 0,
      currentPage: (json['currentPage'] is int)
          ? json['currentPage']
          : int.tryParse(json['currentPage']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": data.map((x) => x.toJson()).toList(),
        "totalPages": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
      };
}

class ReviewsItem {
  final String serviceId;
  final String bookingId;
  final String customerId;
  final String employeeId;
  final String customerName;
  final String employeeName;
  final String comment;
  final double rating;

  ReviewsItem({
    required this.serviceId,
    required this.bookingId,
    required this.customerId,
    required this.employeeId,
    required this.customerName,
    required this.employeeName,
    required this.comment,
    required this.rating,
  });

  factory ReviewsItem.fromJson(Map<String, dynamic> json) {
    return ReviewsItem(
      serviceId: json['serviceId']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      rating: (json['rating'] is double)
          ? json['rating']
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "bookingId": bookingId,
        "customerId": customerId,
        "employeeId": employeeId,
        "customerName": customerName,
        "employeeName": employeeName,
        "comment": comment,
        "rating": rating,
      };
}
