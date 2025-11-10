import 'dart:convert';

// To parse this JSON data
FetchBookingModel fetchBookingModelFromJson(String str) =>
    FetchBookingModel.fromJson(json.decode(str));

String fetchBookingModelToJson(FetchBookingModel data) =>
    json.encode(data.toJson());

class FetchBookingModel {
  final int totalItems;
  final List<BookingItem> data;
  final int totalPages;
  final int pageSize;
  final int currentPage;

  FetchBookingModel({
    required this.totalItems,
    required this.data,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
  });

  factory FetchBookingModel.fromJson(Map<String, dynamic> json) =>
      FetchBookingModel(
        totalItems: json["totalItems"] ?? 0,
        data: List<BookingItem>.from(
            (json["data"] ?? []).map((x) => BookingItem.fromJson(x))),
        totalPages: json["totalPages"] ?? 0,
        pageSize: json["pageSize"] ?? 0,
        currentPage: json["currentPage"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalPages": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
      };
}

class BookingItem {
  final String bookingId;
  final String name;
  final String description;
  final double amount;
  final String paymentStatus;
  final String bookingStatus;
  final DateTime? bookingDate;
  final String userId;
  final String userName;
  final String employeeId;
  final String employeeName;
  final String serviceName;
  final String serviceId;
  final String city;
  final String location;

  BookingItem({
    required this.bookingId,
    required this.name,
    required this.description,
    required this.amount,
    required this.city,
    required this.location,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.bookingDate,
    required this.userId,
    required this.userName,
    required this.employeeId,
    required this.employeeName,
    required this.serviceName,
    required this.serviceId,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        bookingId: json["bookingId"] ?? "",
        name: json["name"] ?? "",
        city: json["location"] ?? "",
        location: json['address'] ?? "",
        description: json["description"] ?? "",
        amount: (json["amount"] ?? 0).toDouble(),
        paymentStatus: json["paymentStatus"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        bookingDate: json["bookingDate"] != null
            ? DateTime.tryParse(json["bookingDate"])
            : null,
        userId: json["userId"] ?? "",
        userName: json["userName"] ?? "",
        employeeId: json["employeeId"] ?? "",
        employeeName: json["employeeName"] ?? "",
        serviceName: json["serviceName"] ?? "",
        serviceId: json["serviceId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "name": name,
        "description": description,
        "amount": amount,
        "paymentStatus": paymentStatus,
        "bookingStatus": bookingStatus,
        "bookingDate": bookingDate?.toIso8601String(),
        "userId": userId,
        "userName": userName,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "serviceName": serviceName,
        "serviceId": serviceId,
      };
}
