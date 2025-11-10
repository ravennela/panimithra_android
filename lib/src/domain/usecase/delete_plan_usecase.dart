import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';

class DeletePlanUseCase {
  final PlanRepository repository;

  DeletePlanUseCase(this.repository);

  Future<Either<String, SuccessModel>> call(String planId) async {
    return await repository.deletePlan(planId);
  }
}
