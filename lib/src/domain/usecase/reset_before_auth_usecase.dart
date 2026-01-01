import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class ResetPasswordBeforeAuthUseCase {
  final UserRepository repository;

  ResetPasswordBeforeAuthUseCase({required this.repository});

  @override
  Future<Either<String, SuccessModel>> call({
    required Map<String, dynamic> body,
  }) async {
    return await repository.resetPasswordBeforeAuth(body: body);
  }
}
