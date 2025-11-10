import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class FetchAdminDashboardUseCase {
  final UserRepository repository;

  FetchAdminDashboardUseCase(this.repository);

  Future<Either<String, AdminDashboardModel>> call() async {
    return await repository.fetchAdminDashboard();
  }
}
