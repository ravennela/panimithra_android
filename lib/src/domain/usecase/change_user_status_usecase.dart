
import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class ChangeUserStatusUseCase {
  final UserRepository userRepository;

  ChangeUserStatusUseCase(this.userRepository);

  Future<Either<String, SuccessModel>> call({
    required String userId,
    required String status,
  }) {
    return userRepository.changeUserStatus(
      userId: userId,
      status: status,
    );
  }
}