import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoriesRepository repository;

  CreateCategoryUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call(Map<String, dynamic> data) async {
    return await repository.createCategory(data);
  }
}
