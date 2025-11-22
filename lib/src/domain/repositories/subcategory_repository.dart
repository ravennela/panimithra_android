import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_subcategory_by_id_model.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class SubcategoryRepository {
  Future<Either<String, FetchSubcategoryModel>> fetchSubcategories({
    required String categoryId,
    required int page,
  });
  Future<Either<String, SuccessModel>> createSubcategory(
      String categoryId, Map<String, dynamic> data);

  Future<Either<String, SuccessModel>> deleteSubCategory(
    String subcategoryId,
  );

  Future<Either<String, FetchSubCategoryByIdModel>> fetchSubcategoryById(
    String subcategoryId,
  );
  Future<Either<String, SuccessModel>> updateSubCategory({
    required Map<String, dynamic> data,
  });
}
