
import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/order_creation_model.dart';
import 'package:panimithra/src/domain/repositories/payments_repository.dart';

class CreateOrderUseCase {
  final EmployeePaymentRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<String, OrderCreationModel>> call({
    required String planId,
  }) async {
    return await repository.createOrder(planId: planId);
  }
}