// To parse this JSON data, do
//
//     final fetchCategoryModel = fetchCategoryModelFromJson(jsonString);

import 'dart:convert';

FetchCategoryModel fetchCategoryModelFromJson(String str) =>
    FetchCategoryModel.fromJson(json.decode(str));

String fetchCategoryModelToJson(FetchCategoryModel data) =>
    json.encode(data.toJson());

class FetchCategoryModel {
  int? totalItems;
  List<CategoryItem>? data;
  int? totalPages;
  int? pageSize;
  int? currentPage;

  FetchCategoryModel({
    this.totalItems,
    this.data,
    this.totalPages,
    this.pageSize,
    this.currentPage,
  });

  factory FetchCategoryModel.fromJson(Map<String, dynamic> json) =>
      FetchCategoryModel(
        totalItems: json["totalItems"],
        data: json["data"] == null
            ? []
            : List<CategoryItem>.from(
                json["data"]!.map((x) => CategoryItem.fromJson(x))),
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

class CategoryItem {
  String? categoryId;
  String? categoryName;
  String? description;
  String? status;
  String? iconUrl;
  int? subCategoriesCount;

  CategoryItem({
    this.categoryId,
    this.categoryName,
    this.description,
    this.status,
    this.iconUrl,
    this.subCategoriesCount,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        categoryId: json["categoryId"] ?? "",
        categoryName: json["categoryName"] ?? "",
        description: json["description"] ?? "",
        status: json["status"] ?? "",
        iconUrl: json["iconUrl"] ?? "",
        subCategoriesCount: json["subCategoriesCount"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "description": description,
        "status": status,
        "iconUrl": iconUrl,
        "subCategoriesCount": subCategoriesCount,
      };
}
