import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class ProviderRegistrationRepository {
  Future<Either<String, SuccessModel>> registrationCheck(
      Map<String, dynamic> data);
}
