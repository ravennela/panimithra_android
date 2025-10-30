import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class FetchCategoriesUseCase {
  final CategoriesRepository repository;

  FetchCategoriesUseCase({required this.repository});

  Future<Either<String, FetchCategoryModel>> call(int page) async {
    return await repository.fetchCategories(page);
  }
}
