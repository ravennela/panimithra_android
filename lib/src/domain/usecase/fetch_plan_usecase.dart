import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_plan_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';

class FetchPlansUseCase {
  final PlanRepository repository;

  FetchPlansUseCase({required this.repository});

  Future<Either<String, FetchPlanModel>> call() async {
    return await repository.fetchPlans();
  }
}
