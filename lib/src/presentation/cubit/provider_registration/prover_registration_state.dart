import 'package:equatable/equatable.dart';

class ProverRegistrationState extends Equatable {
  final String name;
  final String emailId;
  final String mobileNumber;
  final String alternateNumber;
  final String gender;
  final DateTime dateobBirth;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String primaryServiceCategory;
  final int experience;
  final String shortDescription;
  final String password;
  const ProverRegistrationState({
    required this.address,
    required this.alternateNumber,
    required this.password,
    required this.city,
    required this.dateobBirth,
    required this.emailId,
    required this.experience,
    required this.gender,
    required this.mobileNumber,
    required this.name,
    required this.pincode,
    required this.primaryServiceCategory,
    required this.shortDescription,
    required this.state,
  });

  ProverRegistrationState copyWith({
    String? name,
    String? emailId,
    String? mobileNumber,
    String? alternateNumber,
    String? gender,
    DateTime? dateobBirth,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? primaryServiceCategory,
    String? shortDescription,
    String? password,
    int? experience,
  }) {
    return ProverRegistrationState(
      name: name ?? this.name,
      address: address ?? this.address,
      alternateNumber: alternateNumber ?? this.alternateNumber,
      city: city ?? this.city,
      dateobBirth: dateobBirth ?? this.dateobBirth,
      emailId: emailId ?? this.emailId,
      password: password ?? this.password,
      experience: experience ?? this.experience,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      pincode: pincode ?? this.pincode,
      primaryServiceCategory:
          primaryServiceCategory ?? this.primaryServiceCategory,
      shortDescription: shortDescription ?? this.shortDescription,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
    name,
    emailId,
    mobileNumber,
    alternateNumber,
    gender,
    dateobBirth,
    address,
    city,
    state,
    pincode,
    primaryServiceCategory,
    experience,
    shortDescription,
  ];
}
