import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class RequestOtpUseCase {
  final UserRepository repository;

  RequestOtpUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required Map<String, dynamic> body,
  }) async {
    return await repository.requestOtp(body: body);
  }
}
