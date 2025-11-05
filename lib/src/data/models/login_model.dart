// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? userId;
  String? userName;
  String? contactNumber;
  String? emailId;
  String? address;
  double? latitude;
  double? longitude;
  String? profileImageUrl;
  String? gender;
  String? token;
  // DateTime dob;
  String? city;
  String state;
  String? pinCode;
  String role;
  String? status;
  String? alternateNumber;
  String? primaryService;
  int? experiance;
  String? shortBio;

  LoginModel({
    required this.userId,
    required this.userName,
    required this.contactNumber,
    required this.emailId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.profileImageUrl,
    required this.gender,
    required this.token,
    // required this.dob,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.role,
    required this.status,
    required this.alternateNumber,
    required this.primaryService,
    required this.experiance,
    required this.shortBio,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userId: json["userId"] ?? '',
        userName: json["userName"] ?? "",
        contactNumber: json["contactNumber"] ?? "",
        emailId: json["emailId"] ?? "",
        address: json["address"] ?? "",
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        profileImageUrl: json["profileImageUrl"] ?? "",
        gender: json["gender"] ?? "",
        token: json["token"] ?? "",
        //  dob: DateTime.parse(json["dob"]),
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        pinCode: json["pinCode"] ?? "",
        role: json["role"] ?? "",
        status: json["status"] ?? "",
        alternateNumber: json["alternateNumber"] ?? "",
        primaryService: json["primaryService"] ?? "",
        experiance: json["experiance"] ?? 0,
        shortBio: json["shortBio"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "contactNumber": contactNumber,
        "emailId": emailId,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "profileImageUrl": profileImageUrl,
        "gender": gender,
        "token": token,
        // "dob":
        //     "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "city": city,
        "state": state,
        "pinCode": pinCode,
        "role": role,
        "status": status,
        "alternateNumber": alternateNumber,
        "primaryService": primaryService,
        "experiance": experiance,
        "shortBio": shortBio,
      };
}
