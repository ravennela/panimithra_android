import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class RegisterFcmTokenUseCase {
  final UserRepository repository;

  RegisterFcmTokenUseCase(this.repository);

  Future<Either<String, SuccessModel>> call({
    required String deviceToken,
  }) async {
    return await repository.registerFcmToken(
      deviceToken: deviceToken,
    );
  }
}
