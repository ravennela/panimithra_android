// To parse this JSON data, do
//
//     final fetchPlanModel = fetchPlanModelFromJson(jsonString);

import 'dart:convert';

FetchPlanModel fetchPlanModelFromJson(String str) =>
    FetchPlanModel.fromJson(json.decode(str));

String fetchPlanModelToJson(FetchPlanModel data) => json.encode(data.toJson());

class FetchPlanModel {
  List<Datum> data;

  FetchPlanModel({
    required this.data,
  });

  factory FetchPlanModel.fromJson(Map<String, dynamic> json) => FetchPlanModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String planId;
  String planName;
  String planDescription;
  double price;
  int duration;
  String? status;

  Datum({
    required this.planId,
    required this.planName,
    required this.planDescription,
    required this.price,
    required this.duration,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        planId: json["planId"],
        planName: json["planName"],
        planDescription: json["planDescription"],
        price: json["price"],
        duration: json["duration"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "planId": planId,
        "planName": planName,
        "planDescription": planDescription,
        "price": price,
        "duration": duration,
        "status": status,
      };
}
