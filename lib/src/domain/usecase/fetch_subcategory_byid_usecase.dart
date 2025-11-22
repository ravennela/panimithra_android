import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_subcategory_by_id_model.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

class FetchSubcategoryByIdUsecase {
  final SubcategoryRepository repository;

  FetchSubcategoryByIdUsecase(this.repository);

  Future<Either<String, FetchSubCategoryByIdModel>> call(String subcategoryId) {
    return repository.fetchSubcategoryById(subcategoryId);
  }
}
