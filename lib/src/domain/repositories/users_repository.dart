import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';

abstract class UserRepository {
  Future<Either<String, FetchUsersModel>> fetchUsers({
    int? page,
    String? status,
    String? name,
    String? role,
  });
}
