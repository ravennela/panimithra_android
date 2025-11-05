import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class FetchUsersUseCase {
  final UserRepository repository;

  FetchUsersUseCase({required this.repository});

  Future<Either<String, FetchUsersModel>> call({
    int? page,
    String? status,
    String? name,
    String? role,
  }) async {
    return await repository.fetchUsers(
      page: page,
      status: status,
      name: name,
      role: role,
    );
  }
}
