import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

class CreateSubcategoryUseCase {
  final SubcategoryRepository repository;

  CreateSubcategoryUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call(
      String categoryId, Map<String, dynamic> data) async {
    return await repository.createSubcategory(categoryId, data);
  }
}
