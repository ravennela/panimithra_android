import 'package:equatable/equatable.dart';

abstract class FetchUsersEvent extends Equatable {
  const FetchUsersEvent();

  @override
  List<Object?> get props => [];
}

class GetUsersEvent extends FetchUsersEvent {
  final int? page;
  final String? status;
  final String? name;
  final String? role;

  const GetUsersEvent({
    this.page,
    this.status,
    this.name,
    this.role,
  });

  @override
  List<Object?> get props => [page, status, name, role];
}

class GetUserProfileEvent extends FetchUsersEvent {
  final String userId;

  const GetUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetAdminDashboardEvent extends FetchUsersEvent {
  const GetAdminDashboardEvent();

  @override
  List<Object?> get props => [];
}

class GetEmployeeDashboardEvent extends FetchUsersEvent {
  final String userId;

  const GetEmployeeDashboardEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RegisterFcmTokenEvent extends FetchUsersEvent {
  final String deviceToken;

  const RegisterFcmTokenEvent({required this.deviceToken});

  @override
  List<Object?> get props => [deviceToken];
}

class ChangeUserStatusEvent extends FetchUsersEvent {
  final String userId;
  final String status;

  const ChangeUserStatusEvent({
    required this.userId,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, status];
}

class FetchFaqEvent extends FetchUsersEvent {
  const FetchFaqEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordEvent extends FetchUsersEvent {
  final Map<String, dynamic> body;

  const ResetPasswordEvent({required this.body});

  @override
  List<Object?> get props => [body];
}

class RequestOtpEvent extends FetchUsersEvent {
  final Map<String, dynamic> body;

  const RequestOtpEvent({required this.body});

  @override
  List<Object?> get props => [body];
}

class VerifyOtpEvent extends FetchUsersEvent {
  final Map<String, dynamic> body;

  const VerifyOtpEvent({required this.body});

  @override
  List<Object?> get props => [body];
}

class ResetPasswordBeforeAuthEvent extends FetchUsersEvent {
  final Map<String, dynamic> body;

  const ResetPasswordBeforeAuthEvent({
    required this.body,
  });

  @override
  List<Object?> get props => [body];
}

