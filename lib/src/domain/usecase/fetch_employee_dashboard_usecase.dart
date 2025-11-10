import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class FetchEmployeeDashboardUseCase {
  final UserRepository repository;

  FetchEmployeeDashboardUseCase({required this.repository});

  Future<Either<String, EmployeeDashboardModel>> call({
    required String userId,
  }) async {
    return await repository.fetchEmployeeDashboard(userId: userId);
  }
}
