import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';

class CreatePlanUseCase {
  final PlanRepository repository;

  CreatePlanUseCase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required String planName,
    required String description,
    required double price,
    required int duration,
  }) {
    return repository.createPlan(
      planName: planName,
      description: description,
      price: price,
      duration: duration,
    );
  }
}
