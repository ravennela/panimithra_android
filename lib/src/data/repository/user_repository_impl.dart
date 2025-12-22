import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/users_remote_datasource.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';
import 'package:panimithra/src/data/models/faq_model.dart';

import 'package:panimithra/src/domain/repositories/users_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, FetchUsersModel>> fetchUsers({
    int? page,
    String? status,
    String? name,
    String? role,
  }) async {
    try {
      final raw = await remoteDataSource.fetchUsers(
        page: page,
        status: status,
        name: name,
        role: role,
      );

      final model = FetchUsersModel.fromJson(raw);
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
  Future<Either<String, UserProfileModel>> getUserProfile({
    required String userId,
  }) async {
    try {
      final raw = await remoteDataSource.getUserProfile(userId: userId);
      final model = UserProfileModel.fromJson(raw);
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
  Future<Either<String, AdminDashboardModel>> fetchAdminDashboard() async {
    try {
      final raw =
          await remoteDataSource.fetchAdminDashboard(); // call from datasource
      final model = AdminDashboardModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Failed to load dashboard. Please try again later",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, EmployeeDashboardModel>> fetchEmployeeDashboard({
    required String userId,
  }) async {
    try {
      final raw = await remoteDataSource.fetchEmployeeDashboard(userId: userId);
      final model = EmployeeDashboardModel.fromJson(raw);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Error occurred while fetching employee dashboard. Please try again.",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SuccessModel>> registerFcmToken({
    required String deviceToken,
  }) async {
    try {
      final raw = await remoteDataSource.registerFcmToken(
        deviceToken: deviceToken,
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
            "Failed to register FCM token. Please try again.",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SuccessModel>> changeUserStatus({
    required String userId,
    required String status,
  }) async {
    try {
      final response = await remoteDataSource.changeUserStatus(
        userId: userId,
        status: status,
      );

      return Right(SuccessModel.fromJson(response));
    } on SocketException {
      return const Left("No Internet connection. Please try again.");
    } on ServerException catch (e) {
      return Left(e.message ?? "Something went wrong on the server.");
    } on DioException catch (e) {
      return Left(e.message ?? "Request failed. Please try again.");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<FaqModel>>> fetchFaq() async {
    try {
      final raw = await remoteDataSource.fetchFaq();
      final model = List<FaqModel>.from(raw.map((x) => FaqModel.fromJson(x)));
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(
        e.response?.data['error']?.toString() ??
            "Failed to fetch FAQs. Please try again.",
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
