import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_plan_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class PlanRepository {
  /// Fetch paginated list of plans
  //Future<Either<String, SuccessModel>> fetchPlans(int page);

  /// Create a new plan
  Future<Either<String, SuccessModel>> createPlan(
      {required String planName,
      required String description,
      required double price,
      required int duration,
      required String discount,
      required double originalPrice});

  Future<Either<String, FetchPlanModel>> fetchPlans();
  Future<Either<String, SuccessModel>> deletePlan(String planId);
}
