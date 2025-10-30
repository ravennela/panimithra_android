import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/provider_registration_repository.dart';

class ProviderRegistrationUsecase {
  ProviderRegistrationRepository repository;
  ProviderRegistrationUsecase({required this.repository});
  Future<Either<String, SuccessModel>> createProviderUseCase(
      {required Map<String, dynamic> data}) async {
    return repository.registrationCheck(data);
  }
}
