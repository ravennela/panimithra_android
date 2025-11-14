import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/service_remote_data_source.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/data/models/search_service_model.dart';
import 'package:panimithra/src/data/models/service_by_id_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource serviceDataSource;

  ServiceRepositoryImpl({required this.serviceDataSource});

  @override
  Future<Either<String, FetchServiceModel>> fetchServices(int page) async {
    try {
      final raw = await serviceDataSource.fetchServices(page: page);
      // ignore: await_only_futures
      final model = await FetchServiceModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left(
        "No Internet Connection",
      );
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(e.response?.data['error'].toString() ??
          "Error occured Please try again");
    }
  }

  @override
  Future<Either<String, SuccessModel>> createService({
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  }) async {
    try {
      final raw = await serviceDataSource.createService(
        serviceData: serviceData,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      );

      SuccessModel model = SuccessModel.fromJson(raw);

      // Here you can directly return the raw response or parse it into a model if you have one.
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
  Future<Either<String, SuccessModel>> updateService({
    required String serviceId,
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  }) async {
    try {
      final response = await serviceDataSource.updateService(
        serviceId: serviceId,
        serviceData: serviceData,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      );
      final result = SuccessModel.fromJson(response);
      return Right(result);
    } on SocketException {
      return const Left("No Internet connection. Please check your network.");
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Failed to update service.");
    } on ServerException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, FetchSearchServiceModel>> fetchSearchService(
      {int? page,
      String? serviceName,
      String? categoryName,
      String? subCategoryName,
      double? minPrice,
      double? maxPrice,
      double? price,
      String? priceSort}) async {
    try {
      final raw = await serviceDataSource.searchService(
          categoryName: categoryName,
          maxPrice: maxPrice,
          minPrice: minPrice,
          page: page,
          price: price,
          priceSort: priceSort,
          serviceName: serviceName,
          subCategoryName: subCategoryName);

      FetchSearchServiceModel model = FetchSearchServiceModel.fromJson(raw);

      // Here you can directly return the raw response or parse it into a model if you have one.
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
  Future<Either<String, ServiceByIdModel>> fetchServiceById(
      {required String serviceId}) async {
    try {
      // Call datasource
      final raw = await serviceDataSource.fetchServiceById(serviceId);

      // Parse JSON into model
      ServiceByIdModel model = ServiceByIdModel.fromJson(raw);

      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Something went wrong. Please try again.",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
