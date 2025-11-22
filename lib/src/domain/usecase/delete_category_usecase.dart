import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoriesRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<Either<String, SuccessModel>> call(String categoryId) {
    return repository.deleteCategory(categoryId);
  }
}
