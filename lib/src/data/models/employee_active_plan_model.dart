// To parse this JSON data, do
//
//     final employeeActivePlanModel = employeeActivePlanModelFromJson(jsonString);

import 'dart:convert';

EmployeeActivePlanModel employeeActivePlanModelFromJson(String str) =>
    EmployeeActivePlanModel.fromJson(json.decode(str));

String employeeActivePlanModelToJson(EmployeeActivePlanModel data) =>
    json.encode(data.toJson());

class EmployeeActivePlanModel {
  List<Plan> plan;

  EmployeeActivePlanModel({
    required this.plan,
  });

  factory EmployeeActivePlanModel.fromJson(Map<String, dynamic> json) =>
      EmployeeActivePlanModel(
        plan: List<Plan>.from(json["plan"].map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plan": List<dynamic>.from(plan.map((x) => x.toJson())),
      };
}

class Plan {
  String planname;
  double price;
  String id;
  String status;
  DateTime startDate;
  DateTime enDate;

  Plan({
    required this.planname,
    required this.price,
    required this.id,
    required this.status,
    required this.startDate,
    required this.enDate,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        planname: json["planname"],
        price: json["price"],
        id: json["id"],
        status: json["status"],
        startDate: DateTime.parse(json["startDate"]),
        enDate: DateTime.parse(json["enDate"]),
      );

  Map<String, dynamic> toJson() => {
        "planname": planname,
        "price": price,
        "id": id,
        "status": status,
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "enDate":
            "${enDate.year.toString().padLeft(4, '0')}-${enDate.month.toString().padLeft(2, '0')}-${enDate.day.toString().padLeft(2, '0')}",
      };
}
