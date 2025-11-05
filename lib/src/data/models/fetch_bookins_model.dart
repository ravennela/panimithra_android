// To parse this JSON data, do
//
//     final fetchBookingModel = fetchBookingModelFromJson(jsonString);

import 'dart:convert';

FetchBookingModel fetchBookingModelFromJson(String str) =>
    FetchBookingModel.fromJson(json.decode(str));

String fetchBookingModelToJson(FetchBookingModel data) =>
    json.encode(data.toJson());

class FetchBookingModel {
  int totalItems;
  List<BookingItem> data;
  int totalPages;
  int pageSize;
  int currentPage;

  FetchBookingModel({
    required this.totalItems,
    required this.data,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
  });

  factory FetchBookingModel.fromJson(Map<String, dynamic> json) =>
      FetchBookingModel(
        totalItems: json["totalItems"],
        data: List<BookingItem>.from(
            json["data"].map((x) => BookingItem.fromJson(x))),
        totalPages: json["totalPages"],
        pageSize: json["pageSize"],
        currentPage: json["currentPage"],
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
  String bookingId;
  String name;
  String description;
  double amount;
  String paymentStatus;
  String bookingStatus;
  // DateTime bookingDate;
  String userId;
  String userName;
  String employeeId;
  String employeeName;
  String serviceName;
  String serviceId;

  BookingItem({
    required this.bookingId,
    required this.name,
    required this.description,
    required this.amount,
    required this.paymentStatus,
    required this.bookingStatus,
    // required this.bookingDate,
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
        description: json["description"] ?? "",
        amount: json["amount"] ?? 0.0,
        paymentStatus: json["paymentStatus"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        // bookingDate: json["bookingDate"],
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
        // "bookingDate": bookingDate,
        "userId": userId,
        "userName": userName,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "serviceName": serviceName,
        "serviceId": serviceId,
      };
}
