// To parse this JSON data, do
//
//     final fetchUsersModel = fetchUsersModelFromJson(jsonString);

import 'dart:convert';

FetchUsersModel fetchUsersModelFromJson(String str) =>
    FetchUsersModel.fromJson(json.decode(str));

String fetchUsersModelToJson(FetchUsersModel data) =>
    json.encode(data.toJson());

class FetchUsersModel {
  int totalItems;
  List<UserItem> data;
  int totalPages;
  int pageSize;
  int currentPage;

  FetchUsersModel({
    required this.totalItems,
    required this.data,
    required this.totalPages,
    required this.pageSize,
    required this.currentPage,
  });

  factory FetchUsersModel.fromJson(Map<String, dynamic> json) =>
      FetchUsersModel(
        totalItems: json["totalItems"],
        data:
            List<UserItem>.from(json["data"].map((x) => UserItem.fromJson(x))),
        totalPages: json["totalPages"],
        pageSize: json["pageSize"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalPages": totalPages,
        "pageSize": pageSize,
        "currentPage": currentPage,
      };
}

class UserItem {
  String? userId;
  String? userName;
  String? status;
  String? role;
  String? email;
  String? contactNumber;
  String? profileImageUrl;
  String? gender;
  DateTime? dob;
  String? city;
  String? state;
  String? pinCode;
  String? primaryService;
  int? experiance;
  String? shortBio;

  UserItem({
    required this.userId,
    required this.userName,
    required this.status,
    required this.role,
    required this.email,
    required this.contactNumber,
    required this.profileImageUrl,
    required this.gender,
    required this.dob,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.primaryService,
    required this.experiance,
    required this.shortBio,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        userId: json["userId"] ?? "",
        userName: json["userName"] ?? "",
        status: json["status"] ?? "",
        role: json["role"] ?? "",
        email: json["email"] ?? "",
        contactNumber: json["contactNumber"] ?? "",
        profileImageUrl: json["profileImageUrl"] ?? "",
        gender: json["gender"] ?? "",
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        pinCode: json["pinCode"] ?? "",
        primaryService: json["primaryService"] ?? "",
        experiance: json["experiance"] ?? 0,
        shortBio: json["shortBio"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "status": status,
        "role": role,
        "email": email,
        "contactNumber": contactNumber,
        "profileImageUrl": profileImageUrl,
        "gender": gender,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "city": city,
        "state": state,
        "pinCode": pinCode,
        "primaryService": primaryService,
        "experiance": experiance,
        "shortBio": shortBio,
      };
}
