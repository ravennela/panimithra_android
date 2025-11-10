import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';

abstract class FetchUsersState extends Equatable {
  const FetchUsersState();

  @override
  List<Object?> get props => [];
}

/// Initial or idle state
class FetchUsersInitial extends FetchUsersState {}

/// Loading state
class FetchUsersLoading extends FetchUsersState {}

/// Loaded state — contains the successfully fetched users
class FetchUsersLoaded extends FetchUsersState {
  final FetchUsersModel fetchUsersModel;
  final List<UserItem> item;
  final int totalRecords;
  const FetchUsersLoaded(
      {required this.fetchUsersModel,
      required this.item,
      required this.totalRecords});

  @override
  List<Object?> get props => [fetchUsersModel];
}

/// Error state — contains an error message
class FetchUsersError extends FetchUsersState {
  final String message;

  const FetchUsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileLoading extends FetchUsersState {}

/// Loaded state — contains the successfully fetched user profile
class UserProfileLoaded extends FetchUsersState {
  final UserProfileModel userProfileModel;

  const UserProfileLoaded({required this.userProfileModel});

  @override
  List<Object?> get props => [userProfileModel];
}

/// Error state — contains an error message
class UserProfileError extends FetchUsersState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminDashboardLoading extends FetchUsersState {}

/// ✅ Dashboard Loaded State
class AdminDashboardLoaded extends FetchUsersState {
  final AdminDashboardModel dashboardModel;

  const AdminDashboardLoaded({required this.dashboardModel});

  @override
  List<Object?> get props => [dashboardModel];
}

/// ✅ Dashboard Error State
class AdminDashboardError extends FetchUsersState {
  final String message;

  const AdminDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ✅ Employee Dashboard States
class EmployeeDashboardLoading extends FetchUsersState {}

class EmployeeDashboardLoaded extends FetchUsersState {
  final EmployeeDashboardModel employeeDashboardModel;

  const EmployeeDashboardLoaded({required this.employeeDashboardModel});

  @override
  List<Object?> get props => [employeeDashboardModel];
}

class EmployeeDashboardError extends FetchUsersState {
  final String message;

  const EmployeeDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
