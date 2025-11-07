// To parse this JSON data, do
//
//     final topFiveRatingModel = topFiveRatingModelFromJson(jsonString);

import 'dart:convert';

TopFiveRatingModel topFiveRatingModelFromJson(String str) =>
    TopFiveRatingModel.fromJson(json.decode(str));

String topFiveRatingModelToJson(TopFiveRatingModel data) =>
    json.encode(data.toJson());

class TopFiveRatingModel {
  List<Rating>? rating;

  TopFiveRatingModel({
    this.rating,
  });

  factory TopFiveRatingModel.fromJson(Map<String, dynamic> json) =>
      TopFiveRatingModel(
        rating: json["rating"] == null
            ? []
            : List<Rating>.from(json["rating"]!.map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating == null
            ? []
            : List<dynamic>.from(rating!.map((x) => x.toJson())),
      };
}

class Rating {
  String? reviewId;
  String? serviceId;
  String? bookingId;
  String? comment;
  double? rating;
  String? userName;
  String? employeeName;
  String? userId;
  String? employeeId;
  String? serviceName;

  Rating({
    this.reviewId,
    this.serviceId,
    this.bookingId,
    this.comment,
    this.rating,
    this.userName,
    this.employeeName,
    this.userId,
    this.employeeId,
    this.serviceName,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        reviewId: json["reviewId"],
        serviceId: json["serviceId"],
        bookingId: json["bookingId"],
        comment: json["comment"],
        rating: json["rating"],
        userName: json["userName"],
        employeeName: json["employeeName"],
        userId: json["userId"],
        employeeId: json["employeeId"],
        serviceName: json["serviceName"],
      );

  Map<String, dynamic> toJson() => {
        "reviewId": reviewId,
        "serviceId": serviceId,
        "bookingId": bookingId,
        "comment": comment,
        "rating": rating,
        "userName": userName,
        "employeeName": employeeName,
        "userId": userId,
        "employeeId": employeeId,
        "serviceName": serviceName,
      };
}
