// To parse this JSON data, do:
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str) as Map<String, dynamic>);

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? joinDate;
  final String? role;

  const UserProfileModel({
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.joinDate,
    this.role,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      profileImage: json['profileImage']?.toString(),
      joinDate: _parseDate(json['joinDate']),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'profileImage': profileImage,
        'joinDate': joinDate?.toIso8601String(),
        'role': role,
      };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
