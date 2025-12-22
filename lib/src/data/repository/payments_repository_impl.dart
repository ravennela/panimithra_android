import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/payments_remote_datasource.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/data/models/order_creation_model.dart';
import 'package:panimithra/src/domain/repositories/payments_repository.dart';

class EmployeePaymentRepositoryImpl implements EmployeePaymentRepository {
  final EmployeePaymentRemoteDataSource remoteDataSource;

  EmployeePaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, EmployeeActivePlanModel>> fetchEmployeePayments({
    required String userId,
  }) async {
    try {
      final response =
          await remoteDataSource.fetchEmployeePayments(userId: userId);
      final result = EmployeeActivePlanModel.fromJson(response);
      return Right(result);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, OrderCreationModel>> createOrder({
    required String planId,
  }) async {
    try {
      final response = await remoteDataSource.createOrder(planId: planId);
      final model = OrderCreationModel.fromJson(response);
      return Right(model);
    } on ServerException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
