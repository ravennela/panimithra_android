import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class SubcategoryRepository {
  Future<Either<String, FetchSubcategoryModel>> fetchSubcategories({
    required String categoryId,
    required int page,
  });
  Future<Either<String, SuccessModel>> createSubcategory(
      String categoryId, Map<String, dynamic> data);
}
