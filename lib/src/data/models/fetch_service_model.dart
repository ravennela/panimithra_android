// To parse this JSON data, do
//
//     final fetchServiceModel = fetchServiceModelFromJson(jsonString);

import 'dart:convert';

FetchServiceModel fetchServiceModelFromJson(String str) =>
    FetchServiceModel.fromJson(json.decode(str));

String fetchServiceModelToJson(FetchServiceModel data) =>
    json.encode(data.toJson());

class FetchServiceModel {
  int? totalItems;
  List<ServiceItem> data; // Non-nullable with default empty list
  int? totalPages;
  int? pageSize;
  int? currentPage;

  FetchServiceModel({
    this.totalItems,
    this.data = const [],
    this.totalPages,
    this.pageSize,
    this.currentPage,
  });

  factory FetchServiceModel.fromJson(Map<String, dynamic> json) =>
      FetchServiceModel(
        totalItems: json["totalItems"],
        data: (json["data"] as List?)
                ?.map((x) => ServiceItem.fromJson(x))
                .toList() ??
            [],
        totalPages: json["totalPages"],
        pageSize: json["pageSize"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": data.map((x) => x.toJson()).toList(),
        "totalPages": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
      };
}

class ServiceItem {
  String? id;
  String? serviceName;
  String? categoryName;
  String? description;
  double? price;
  String? status;
  String? categoryId;
  String? subCategoryId;
  String? startTime;
  String? endTime;

  ServiceItem({
    this.id,
    this.serviceName,
    this.startTime,
    this.endTime,
    this.categoryName,
    this.description,
    this.price,
    this.status,
    this.categoryId,
    this.subCategoryId,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
        id: json["id"],
        serviceName: json["serviceName"],
        categoryName: json["categoryName"],
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        description: json["description"],
        price: json["price"] ?? 0.0,
        status: json["status"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceName": serviceName,
        "categoryName": categoryName,
        "description": description,
        "price": price,
        "status": status,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
      };
}
