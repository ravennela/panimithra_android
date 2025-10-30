// To parse this JSON data, do
//
//     final fetchSubcategoryModel = fetchSubcategoryModelFromJson(jsonString);

import 'dart:convert';

FetchSubcategoryModel fetchSubcategoryModelFromJson(String str) =>
    FetchSubcategoryModel.fromJson(json.decode(str));

String fetchSubcategoryModelToJson(FetchSubcategoryModel data) =>
    json.encode(data.toJson());

class FetchSubcategoryModel {
  int? totalItems;
  List<SubcategoryItem>? data;
  int? totalPages;
  int? pageSize;
  int? currentPage;

  FetchSubcategoryModel({
    this.totalItems,
    this.data,
    this.totalPages,
    this.pageSize,
    this.currentPage,
  });

  factory FetchSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      FetchSubcategoryModel(
        totalItems: json["totalItems"],
        data: json["data"] == null
            ? []
            : List<SubcategoryItem>.from(
                json["data"]!.map((x) => SubcategoryItem.fromJson(x))),
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

class SubcategoryItem {
  String? categoryId;
  String? categoryName;
  String? description;
  String? status;
  String? iconUrl;

  SubcategoryItem({
    this.categoryId,
    this.categoryName,
    this.description,
    this.status,
    this.iconUrl,
  });

  factory SubcategoryItem.fromJson(Map<String, dynamic> json) =>
      SubcategoryItem(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        description: json["description"],
        status: json["status"],
        iconUrl: json["iconUrl"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "description": description,
        "status": status,
        "iconUrl": iconUrl,
      };
}
