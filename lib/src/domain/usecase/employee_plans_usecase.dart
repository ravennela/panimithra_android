import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/domain/repositories/payments_repository.dart';

class GetEmployeePaymentsUseCase {
  final EmployeePaymentRepository repository;

  GetEmployeePaymentsUseCase({required this.repository});

  Future<Either<String, EmployeeActivePlanModel>> execute({
    required String userId,
  }) async {
    return await repository.fetchEmployeePayments(userId: userId);
  }
}
