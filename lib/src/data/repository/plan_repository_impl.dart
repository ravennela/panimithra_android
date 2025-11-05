import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/data/datasource/remote/plan_remote_datasource.dart';
import 'package:panimithra/src/data/models/fetch_plan_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';
import 'package:panimithra/src/core/error/exceptions.dart'; // if you have ServerException defined

class PlanRepositoryImpl implements PlanRepository {
  final CreatePlanRemoteDataSource remoteDataSource;

  PlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, SuccessModel>> createPlan({
    required String planName,
    required String description,
    required double price,
    required int duration,
  }) async {
    try {
      final raw = await remoteDataSource.createPlan(
        planName: planName,
        description: description,
        price: price,
        duration: duration,
      );

      final model = SuccessModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Error occurred. Please try again",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FetchPlanModel>> fetchPlans() async {
    try {
      final raw = await remoteDataSource.fetchPlans();

      final model = FetchPlanModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Error occurred. Please try again",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  
}
