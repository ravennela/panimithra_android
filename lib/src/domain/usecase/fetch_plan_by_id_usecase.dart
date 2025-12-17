import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/plan_by_id_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';

class FetchPlanByIdUseCase {
  final PlanRepository repository;
  FetchPlanByIdUseCase(this.repository);
  @override
  Future<Either<String, PlanById>> call(String planId) async {
    return await repository.fetchPlanById(planId);
  }
}
