// To parse this JSON data, do
//
//     final serviceByIdModel = serviceByIdModelFromJson(jsonString);

import 'dart:convert';

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
  String employeeName;
  int employeeExperiance;
  String? employeeId;
  dynamic imageUrl;
  List<dynamic> reviews;

  ServiceByIdModel({
    required this.serviceId,
    required this.serviceName,
    required this.description,
    required this.avaragerating,
    required this.price,
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
        description: json["description"] ?? "",
        avaragerating: json["avaragerating"] ?? 0.0,
        price: json["price"] ?? 0.0,
        employeeName: json["employeeName"],
        employeeExperiance: json["employeeExperiance"],
        imageUrl: json["imageUrl"],
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
