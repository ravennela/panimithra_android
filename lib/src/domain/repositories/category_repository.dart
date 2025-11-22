import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_category_by_id_model.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class CategoriesRepository {
  Future<Either<String, FetchCategoryModel>> fetchCategories(int page);
  Future<Either<String, SuccessModel>> createCategory(
      Map<String, dynamic> data);
  Future<Either<String, SuccessModel>> deleteCategory(
    String categoryId,
  );
  Future<Either<String, FetchCategoryByIdModel>> fetchCategoryById(
    String categoryId,
  );
  Future<Either<String, SuccessModel>> updateCategory(Map<String, dynamic> data);
}
