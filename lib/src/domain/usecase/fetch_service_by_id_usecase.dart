import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/service_by_id_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class FetchServiceByIdUseCase {
  final ServiceRepository repository;

  FetchServiceByIdUseCase(this.repository);

  Future<Either<String, ServiceByIdModel>> call(String serviceId) async {
    return await repository.fetchServiceById(serviceId: serviceId);
  }
}
