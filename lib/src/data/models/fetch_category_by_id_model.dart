// To parse this JSON data, do
//
//     final fetchCategoryByIdModel = fetchCategoryByIdModelFromJson(jsonString);

import 'dart:convert';

FetchCategoryByIdModel fetchCategoryByIdModelFromJson(String str) =>
    FetchCategoryByIdModel.fromJson(json.decode(str));

String fetchCategoryByIdModelToJson(FetchCategoryByIdModel data) =>
    json.encode(data.toJson());

class FetchCategoryByIdModel {
  String categoryId;
  String categoryName;
  String status;
  String iconUrl;
  String description;

  FetchCategoryByIdModel({
    required this.categoryId,
    required this.categoryName,
    required this.status,
    required this.iconUrl,
    required this.description,
  });

  factory FetchCategoryByIdModel.fromJson(Map<String, dynamic> json) =>
      FetchCategoryByIdModel(
        categoryId: json["categoryId"] ?? "",
        categoryName: json["categoryName"] ?? "",
        status: json["status"] ?? "",
        iconUrl: json["iconUrl"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "status": status,
        "iconUrl": iconUrl,
        "description": description,
      };
}
