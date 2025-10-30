// To parse this JSON data, do
//
//     final successModel = successModelFromJson(jsonString);

import 'dart:convert';

SuccessModel successModelFromJson(String str) =>
    SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  String? userId;
  String? message;

  SuccessModel({
    this.userId,
    this.message,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        userId: json["userId"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "message": message,
      };
}
