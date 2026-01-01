import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class ResetPasswordUseCase {
  final UserRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required Map<String, dynamic> body,
  }) async {
    return await repository.resetPassword(body: body);
  }
}
