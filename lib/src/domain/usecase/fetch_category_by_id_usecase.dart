
import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_category_by_id_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class FetchCategoryByIdUseCase {
  final CategoriesRepository repository;
  FetchCategoryByIdUseCase(this.repository);
  Future<Either<String, FetchCategoryByIdModel>> call(String categoryId) {
    return repository.fetchCategoryById(categoryId);
  }
}