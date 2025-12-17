// To parse this JSON data, do
//
//     final planById = planByIdFromJson(jsonString);

import 'dart:convert';

PlanById planByIdFromJson(String str) => PlanById.fromJson(json.decode(str));

String planByIdToJson(PlanById data) => json.encode(data.toJson());

class PlanById {
  PlanItem? data;

  PlanById({
    this.data,
  });

  factory PlanById.fromJson(Map<String, dynamic> json) => PlanById(
        data: json["data"] == null ? null : PlanItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class PlanItem {
  String? planId;
  String? planName;
  String? planDescription;
  double? price;
  int? duration;
  String? status;
  String? discount;
  double? originalPrice;

  PlanItem({
    this.planId,
    this.planName,
    this.planDescription,
    this.price,
    this.duration,
    this.status,
    this.discount,
    this.originalPrice,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
        planId: json["planId"],
        planName: json["planName"],
        planDescription: json["planDescription"],
        price: json["price"],
        duration: json["duration"],
        status: json["status"],
        discount: json["discount"],
        originalPrice: json["originalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "planId": planId,
        "planName": planName,
        "planDescription": planDescription,
        "price": price,
        "duration": duration,
        "status": status,
        "discount": discount,
        "originalPrice": originalPrice,
      };
}
