    import 'package:dartz/dartz.dart';
    import 'package:panimithra/src/data/models/success_model.dart';
    import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

    class UpdateSubCategoryUseCase {
      final SubcategoryRepository repository;

      UpdateSubCategoryUseCase({required this.repository});

      Future<Either<String, SuccessModel>> call(Map<String, dynamic> data) async {
        return await repository.updateSubCategory(data: data);
      }
    }
