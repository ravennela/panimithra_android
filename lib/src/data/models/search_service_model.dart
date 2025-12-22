// To parse this JSON data, do
//
//     final fetchSearchServiceModel = fetchSearchServiceModelFromJson(jsonString);

import 'dart:convert';

FetchSearchServiceModel fetchSearchServiceModelFromJson(String str) =>
    FetchSearchServiceModel.fromJson(json.decode(str));

String fetchSearchServiceModelToJson(FetchSearchServiceModel data) =>
    json.encode(data.toJson());

class FetchSearchServiceModel {
  int? totalItems;
  List<SearchServiceItem>? data;
  int? totalPages;
  int? pageSize;
  int? currentPage;

  FetchSearchServiceModel({
    this.totalItems,
    this.data,
    this.totalPages,
    this.pageSize,
    this.currentPage,
  });

  factory FetchSearchServiceModel.fromJson(Map<String, dynamic> json) =>
      FetchSearchServiceModel(
        totalItems: json["totalItems"],
        data: json["data"] == null
            ? []
            : List<SearchServiceItem>.from(
                json["data"]!.map((x) => SearchServiceItem.fromJson(x))),
        totalPages: json["totalPages"],
        pageSize: json["pageSize"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "totalPages": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
      };
}

class SearchServiceItem {
  String? serviceName;
  String? description;
  String? status;
  String? address;
  double? latitude;
  double? longitude;
  int? duration;
  String? serviceId;
  String? startTime;
  String? endTime;
  List<dynamic>? bookings;
  String? categoryName;
  String? categoryDescription;
  String? subCategoryName;
  String? subCategoroyDescription;
  double? avgrating;
  double? price;
  String? iconUrl;
  String? employeeName;
  String? employeeId;
  String? mobileNumber;
  DateTime? createdAt;

  SearchServiceItem(
      {this.serviceName,
      this.description,
      this.status,
      this.address,
      this.latitude,
      this.createdAt,
      this.longitude,
      this.duration,
      this.serviceId,
      this.iconUrl,
      this.bookings,
      this.startTime,
      this.endTime,
      this.categoryName,
      this.categoryDescription,
      this.subCategoryName,
      this.subCategoroyDescription,
      this.avgrating,
      this.price,
      this.employeeId,
      this.employeeName,
      this.mobileNumber});

  factory SearchServiceItem.fromJson(Map<String, dynamic> json) =>
      SearchServiceItem(
          serviceName: json["serviceName"],
          description: json["description"],
          status: json["status"],
          iconUrl: json["iconUrl"],
          createdAt: json["createdAt"] != null
              ? DateTime.tryParse(json["createdAt"])
              : null,
          startTime: json["availableStartTime"] ?? "",
          endTime: json["availableEndTime"] ?? "",
          address: json["address"],
          latitude: json["latitude"]?.toDouble(),
          longitude: json["longitude"]?.toDouble(),
          duration: json["duration"],
          serviceId: json["serviceId"],
          bookings: json["bookings"] == null
              ? []
              : List<dynamic>.from(json["bookings"]!.map((x) => x)),
          categoryName: json["categoryName"],
          categoryDescription: json["categoryDescription"],
          subCategoryName: json["subCategoryName"],
          subCategoroyDescription: json["subCategoroyDescription"],
          avgrating: json["avgrating"]?.toDouble(),
          price: json["price"] ?? 0.0,
          employeeId: json["employeeId"] ?? "",
          employeeName: json["employeeName"] ?? '',
          mobileNumber: json["mobileNumber"] ?? "");

  Map<String, dynamic> toJson() => {
        "serviceName": serviceName,
        "description": description,
        "status": status,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "duration": duration,
        "serviceId": serviceId,
        "bookings":
            bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x)),
        "categoryName": categoryName,
        "categoryDescription": categoryDescription,
        "subCategoryName": subCategoryName,
        "subCategoroyDescription": subCategoroyDescription,
        "avgrating": avgrating,
        "price": price,
        "mobileNumber": mobileNumber,
      };
}
