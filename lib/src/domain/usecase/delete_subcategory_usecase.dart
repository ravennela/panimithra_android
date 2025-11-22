import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

class DeleteSubcategoryUseCase {
  final SubcategoryRepository repository;
  DeleteSubcategoryUseCase(this.repository);
  Future<Either<String, SuccessModel>> call(String subcategoryId) {
    return repository.deleteSubCategory(subcategoryId);
  }
}
