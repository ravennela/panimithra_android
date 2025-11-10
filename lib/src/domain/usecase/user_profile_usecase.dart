import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class GetUserProfileUsecase {
  final UserRepository repository;

  GetUserProfileUsecase({required this.repository});

  Future<Either<String, UserProfileModel>> call({
    required String userId,
  }) async {
    return await repository.getUserProfile(userId: userId);
  }
}
