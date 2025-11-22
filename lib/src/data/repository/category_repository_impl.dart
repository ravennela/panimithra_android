// Remote Data Source
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/category_remote_datasource.dart';
import 'package:panimithra/src/data/models/fetch_category_by_id_model.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  FetchCategoryRemoteDataSourceImpl remoteDataSource;
  CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, FetchCategoryModel>> fetchCategories(int page) async {
    try {
      final raw = await remoteDataSource.fetchCategories(page);
      // ignore: await_only_futures
      final model = await FetchCategoryModel.fromJson(raw);
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
  Future<Either<String, SuccessModel>> createCategory(
      Map<String, dynamic> data) async {
    try {
      final raw = await remoteDataSource.createCategory(data);
      // ignore: await_only_futures
      final model = await SuccessModel.fromJson(raw);
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
  Future<Either<String, SuccessModel>> deleteCategory(String categoryId) async {
    try {
      final raw = await remoteDataSource.deleteCategory(categoryId: categoryId);
      final model = SuccessModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error'].toString() ??
            "Error occured Please try again",
      );
    }
  }

  @override
  Future<Either<String, FetchCategoryByIdModel>> fetchCategoryById(
    String categoryId,
  ) async {
    try {
      final raw = await remoteDataSource.fetchCategoryById(
        categoryId: categoryId,
      );

      final model = FetchCategoryByIdModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error'].toString() ??
            "Error occured Please try again",
      );
    }
  }

  @override
  Future<Either<String, SuccessModel>> updateCategory(
      Map<String, dynamic> data) async {
    try {
      final raw = await remoteDataSource.updateCategory(data: data);
      final model =  SuccessModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(e.response?.data['error'].toString() ??
          "Error occurred. Please try again.");
    }
  }
}
