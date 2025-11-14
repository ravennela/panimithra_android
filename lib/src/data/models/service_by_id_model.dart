// To parse this JSON data, do
//
//     final serviceByIdModel = serviceByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

ServiceByIdModel serviceByIdModelFromJson(String str) =>
    ServiceByIdModel.fromJson(json.decode(str));

String serviceByIdModelToJson(ServiceByIdModel data) =>
    json.encode(data.toJson());

class ServiceByIdModel {
  String serviceId;
  String serviceName;
  String description;
  double avaragerating;
  double price;
  String? categoryName;
  String? subCategoryName;
  String employeeName;
  int employeeExperiance;
  String? addInfoOne;
  String? addInfoTwo;
  String? addInfoThree;
  int? totalReviewCount;
  String? employeeId;
  String? imageUrl;
  List<dynamic> reviews;
  String? address;
  TimeOfDay? timeIn;
  TimeOfDay? timeOut;
  String categoryId;
  String sabCategoryId;
  List<String> datesSelected;

  ServiceByIdModel({
    required this.serviceId,
    required this.serviceName,
    required this.description,
    required this.avaragerating,
    required this.price,
    this.addInfoOne,
    this.addInfoTwo,
    required this.sabCategoryId,
    required this.categoryId,
    required this.datesSelected,
    this.addInfoThree,
    this.categoryName,
    this.subCategoryName,
    this.totalReviewCount,
    this.address,
    this.timeIn,
    this.timeOut,
    required this.employeeId,
    required this.employeeName,
    required this.employeeExperiance,
    required this.imageUrl,
    required this.reviews,
  });

  factory ServiceByIdModel.fromJson(Map<String, dynamic> json) =>
      ServiceByIdModel(
        serviceId: json["serviceId"] ?? "",
        employeeId: json["employeeId"] ?? "",
        serviceName: json["serviceName"] ?? "",
        sabCategoryId: json["subCategoryId"] ?? '',
        description: json["description"] ?? "",
        categoryId: json["categoryId"] ?? "",
        categoryName: json["categoryName"] ?? "",
        subCategoryName: json["subCategoryName"] ?? "",
        totalReviewCount: json["totalReviewCount"] ?? 0,
        addInfoOne: json["addInfoOne"] ?? "",
        datesSelected: json["availableDates"] == null
            ? []
            : List<String>.from(
                json["availableDates"].map((x) => x.toString())),
        addInfoTwo: json["addInfoTwo"] ?? "",
        addInfoThree: json["addInfoThree"] ?? "",
        avaragerating: json["avaragerating"] ?? 0.0,
        price: json["price"] ?? 0.0,
        address: json["address"] ?? "",
        timeIn: parseTimeOfDay(json["startTime"]),
        timeOut: parseTimeOfDay(json["endTime"]),
        employeeName: json["employeeName"],
        employeeExperiance: json["employeeExperiance"],
        imageUrl: json["iconUrl"],
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "serviceName": serviceName,
        "description": description,
        "avaragerating": avaragerating,
        "price": price,
        "employeeName": employeeName,
        "employeeExperiance": employeeExperiance,
        "imageUrl": imageUrl,
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
      };
}

TimeOfDay? parseTimeOfDay(String? timeString) {
  if (timeString == null || timeString.isEmpty) return null;
  final parts = timeString.split(":");
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1]) ?? 0;
  return TimeOfDay(hour: hour, minute: minute);
}
