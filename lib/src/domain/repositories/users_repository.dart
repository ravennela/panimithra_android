import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';

abstract class UserRepository {
  Future<Either<String, FetchUsersModel>> fetchUsers({
    int? page,
    String? status,
    String? name,
    String? role,
  });
  Future<Either<String, UserProfileModel>> getUserProfile({
    required String userId,
  });
  Future<Either<String, AdminDashboardModel>> fetchAdminDashboard();

  Future<Either<String, EmployeeDashboardModel>> fetchEmployeeDashboard(
      {required String userId});
}
