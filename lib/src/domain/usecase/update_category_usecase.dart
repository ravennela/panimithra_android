

import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoriesRepository repository;

  UpdateCategoryUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call(Map<String, dynamic> data) async {
    return await repository.updateCategory(data);
  }
}