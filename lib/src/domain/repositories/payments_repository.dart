import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/data/models/order_creation_model.dart';

abstract class EmployeePaymentRepository {
  Future<Either<String, EmployeeActivePlanModel>> fetchEmployeePayments({
    required String userId,
  });

  Future<Either<String, OrderCreationModel>> createOrder({
    required String planId,
  });
}
