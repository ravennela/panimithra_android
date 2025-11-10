import 'dart:convert';

// To parse this JSON data
FetchPlanModel fetchPlanModelFromJson(String str) =>
    FetchPlanModel.fromJson(json.decode(str));

String fetchPlanModelToJson(FetchPlanModel data) => json.encode(data.toJson());

class FetchPlanModel {
  final List<PlanItem> data;

  FetchPlanModel({
    required this.data,
  });

  factory FetchPlanModel.fromJson(Map<String, dynamic> json) => FetchPlanModel(
        data: (json["data"] == null)
            ? []
            : List<PlanItem>.from(
                (json["data"] as List).map((x) => PlanItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PlanItem {
  final String planId;
  final String planName;
  final String planDescription;
  final double price;
  final int duration;
  final String status;
  final String discount;
  final double originalPrice;

  PlanItem({
    required this.planId,
    required this.planName,
    required this.planDescription,
    required this.price,
    required this.duration,
    required this.status,
    required this.discount,
    required this.originalPrice,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
        planId: json["planId"] ?? "",
        planName: json["planName"] ?? "",
        planDescription: json["planDescription"] ?? "",
        price: json["price"] ?? 0.0,
        duration: (json["duration"] ?? 0).toInt(),
        status: json["status"] ?? "",
        discount: json["discount"] ?? "",
        originalPrice: json["originalPrice"] ?? 0.0,
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

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
