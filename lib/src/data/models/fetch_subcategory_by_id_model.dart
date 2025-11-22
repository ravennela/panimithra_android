// To parse this JSON data, do
//
//     final fetchSubCategoryByIdModel = fetchSubCategoryByIdModelFromJson(jsonString);

import 'dart:convert';

FetchSubCategoryByIdModel fetchSubCategoryByIdModelFromJson(String str) =>
    FetchSubCategoryByIdModel.fromJson(json.decode(str));

String fetchSubCategoryByIdModelToJson(FetchSubCategoryByIdModel data) =>
    json.encode(data.toJson());

class FetchSubCategoryByIdModel {
  String categoryId;
  String subCategoryId;
  String categoryName;
  String subCategoryname;
  String status;
  String iconUrl;
  String description;

  FetchSubCategoryByIdModel({
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
    required this.subCategoryname,
    required this.status,
    required this.iconUrl,
    required this.description,
  });

  factory FetchSubCategoryByIdModel.fromJson(Map<String, dynamic> json) =>
      FetchSubCategoryByIdModel(
        categoryId: json["categoryId"] ?? "",
        subCategoryId: json["subCategoryId"] ?? "",
        categoryName: json["categoryName"] ?? "",
        subCategoryname: json["subCategoryname"] ?? "",
        status: json["status"] ?? "",
        iconUrl: json["iconUrl"] ?? "",
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "categoryName": categoryName,
        "subCategoryname": subCategoryname,
        "status": status,
        "iconUrl": iconUrl,
        "description": description,
      };
}
