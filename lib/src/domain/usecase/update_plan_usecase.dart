
import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';

class UpdatePlanUseCase {
  final PlanRepository repository;

  UpdatePlanUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required String planId,
    required Map<String, dynamic> body,
  }) async {
    return await repository.updatePlan(
      planId: planId,
      body: body,
    );
  }
}
