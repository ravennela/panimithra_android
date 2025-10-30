import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

class FetchSubcategoriesUseCase {
  final SubcategoryRepository repository;

  FetchSubcategoriesUseCase({required this.repository});

  Future<Either<String, FetchSubcategoryModel>> call({
    required String categoryId,
    required int page,
  }) async {
    return await repository.fetchSubcategories(
      categoryId: categoryId,
      page: page,
    );
  }
}
