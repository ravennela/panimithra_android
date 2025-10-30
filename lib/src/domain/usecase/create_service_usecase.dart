import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class CreateServiceUseCase {
  final ServiceRepository repository;

  CreateServiceUseCase(this.repository);

  Future<Either<String, SuccessModel>> call({
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  }) async {
    return await repository.createService(
      serviceData: serviceData,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );
  }
}
