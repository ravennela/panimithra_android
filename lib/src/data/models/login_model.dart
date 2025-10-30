// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? token;
  User? user;

  LoginModel({
    this.token,
    this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? name;
  String? contactNumber;
  String? emailId;
  String? password;
  String? address;
  double? latitude;
  double? longitude;
  String? profileImageUrl;
  String? gender;
  dynamic dateOfBirth;
  String? city;
  String? state;
  String? pincode;
  String? role;
  String? status;
  dynamic alternateNumber;
  dynamic primaryService;
  int? experiance;
  dynamic shortBio;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? services;
  List<dynamic>? customerBookings;
  List<dynamic>? employeeBookings;
  List<dynamic>? customerReviews;
  List<dynamic>? employeeReviews;
  List<dynamic>? subscriptions;

  User({
    this.id,
    this.name,
    this.contactNumber,
    this.emailId,
    this.password,
    this.address,
    this.latitude,
    this.longitude,
    this.profileImageUrl,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.state,
    this.pincode,
    this.role,
    this.status,
    this.alternateNumber,
    this.primaryService,
    this.experiance,
    this.shortBio,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.services,
    this.customerBookings,
    this.employeeBookings,
    this.customerReviews,
    this.employeeReviews,
    this.subscriptions,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        contactNumber: json["contactNumber"],
        emailId: json["emailId"],
        password: json["password"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        profileImageUrl: json["profileImageUrl"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        role: json["role"],
        status: json["status"],
        alternateNumber: json["alternateNumber"],
        primaryService: json["primaryService"],
        experiance: json["experiance"],
        shortBio: json["shortBio"],
        deviceToken: json["deviceToken"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        services: json["services"] == null
            ? []
            : List<dynamic>.from(json["services"]!.map((x) => x)),
        customerBookings: json["customerBookings"] == null
            ? []
            : List<dynamic>.from(json["customerBookings"]!.map((x) => x)),
        employeeBookings: json["employeeBookings"] == null
            ? []
            : List<dynamic>.from(json["employeeBookings"]!.map((x) => x)),
        customerReviews: json["customerReviews"] == null
            ? []
            : List<dynamic>.from(json["customerReviews"]!.map((x) => x)),
        employeeReviews: json["employeeReviews"] == null
            ? []
            : List<dynamic>.from(json["employeeReviews"]!.map((x) => x)),
        subscriptions: json["subscriptions"] == null
            ? []
            : List<dynamic>.from(json["subscriptions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNumber": contactNumber,
        "emailId": emailId,
        "password": password,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "profileImageUrl": profileImageUrl,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "city": city,
        "state": state,
        "pincode": pincode,
        "role": role,
        "status": status,
        "alternateNumber": alternateNumber,
        "primaryService": primaryService,
        "experiance": experiance,
        "shortBio": shortBio,
        "deviceToken": deviceToken,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "services":
            services == null ? [] : List<dynamic>.from(services!.map((x) => x)),
        "customerBookings": customerBookings == null
            ? []
            : List<dynamic>.from(customerBookings!.map((x) => x)),
        "employeeBookings": employeeBookings == null
            ? []
            : List<dynamic>.from(employeeBookings!.map((x) => x)),
        "customerReviews": customerReviews == null
            ? []
            : List<dynamic>.from(customerReviews!.map((x) => x)),
        "employeeReviews": employeeReviews == null
            ? []
            : List<dynamic>.from(employeeReviews!.map((x) => x)),
        "subscriptions": subscriptions == null
            ? []
            : List<dynamic>.from(subscriptions!.map((x) => x)),
      };
}
