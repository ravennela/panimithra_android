import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/subcategory_remote_datasource.dart';
import 'package:panimithra/src/data/models/fetch_subcategory_by_id_model.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  SubcategoryRemoteDataSourceImpl remoteDataSource;
  SubcategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, FetchSubcategoryModel>> fetchSubcategories({
    required String categoryId,
    required int page,
  }) async {
    try {
      final raw = await remoteDataSource.fetchSubcategories(
        categoryId: categoryId,
        page: page,
      );
      // ignore: await_only_futures
      final model = await FetchSubcategoryModel.fromJson(raw);
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
  Future<Either<String, SuccessModel>> createSubcategory(
      String categoryId, Map<String, dynamic> data) async {
    try {
      final raw = await remoteDataSource.createSubCategory(
          categoryId: categoryId, data: data);
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
  Future<Either<String, SuccessModel>> deleteSubCategory(
    String subcategoryId,
  ) async {
    try {
      final result = await remoteDataSource.deleteSubCategory(
        subcategoryId: subcategoryId,
      );
      return Right(SuccessModel.fromJson(result));
    } on SocketException {
      return const Left("No internet connection");
    } on DioException catch (e) {
      return Left(e.message ?? "Something went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FetchSubCategoryByIdModel>> fetchSubcategoryById(
      String subcategoryId) async {
    try {
      final raw = await remoteDataSource.fetchSubcategoryById(
        subcategoryId: subcategoryId,
      );

      final model = FetchSubCategoryByIdModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error'].toString() ??
            "Error occurred. Please try again",
      );
    }
  }

  @override
  Future<Either<String, SuccessModel>> updateSubCategory({
    required Map<String, dynamic> data,
  }) async {
    try {
      // ID is taken from map
      final raw = await remoteDataSource.updateSubCategory(data: data);
      final model = SuccessModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      throw const SocketException("No internet connection");
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on DioException catch (e) {
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
