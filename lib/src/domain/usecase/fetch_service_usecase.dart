import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class FetchServicesUseCase {
  final ServiceRepository repository;

  FetchServicesUseCase({required this.repository});

  Future<Either<String, FetchServiceModel>> call(int page) async {
    return await repository.fetchServices(page);
  }
}
