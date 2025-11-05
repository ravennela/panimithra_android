// To parse this JSON data, do
//
//     final orderCreationModel = orderCreationModelFromJson(jsonString);

import 'dart:convert';

OrderCreationModel orderCreationModelFromJson(String str) =>
    OrderCreationModel.fromJson(json.decode(str));

String orderCreationModelToJson(OrderCreationModel data) =>
    json.encode(data.toJson());

class OrderCreationModel {
  String razorpayOrderId;
  double amount;
  String currency;
  String subscriptionId;
  String status;

  OrderCreationModel({
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    required this.subscriptionId,
    required this.status,
  });

  factory OrderCreationModel.fromJson(Map<String, dynamic> json) =>
      OrderCreationModel(
        razorpayOrderId: json["razorpayOrderId"],
        amount: json["amount"]?.toDouble(),
        currency: json["currency"],
        subscriptionId: json["subscriptionId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "razorpayOrderId": razorpayOrderId,
        "amount": amount,
        "currency": currency,
        "subscriptionId": subscriptionId,
        "status": status,
      };
}
