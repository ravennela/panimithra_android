import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class UpdateServiceUseCase {
  final ServiceRepository repository;

  UpdateServiceUseCase(this.repository);

  Future<Either<String, SuccessModel>> call({
    required String serviceId,
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  }) async {
    return await repository.updateService(
      serviceId: serviceId,
      serviceData: serviceData,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );
  }
}
