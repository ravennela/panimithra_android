import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/data/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/utils/typedef.dart';
import '../../domain/entities/login.dart';

import '../datasource/remote/login_remote_datasource.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, LoginModel>> createlogin(
      Map<String, dynamic> data) async {
    try {
      final raw = await remoteDataSource.createlogin(data);
      final model = LoginModel.fromJson(raw);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(ApiConstants.token, model.token.toString());
      preferences.setString(ApiConstants.role, model.user!.role.toString());
      preferences.setString(ApiConstants.userId, model.user!.id.toString());
      preferences.setString(ApiConstants.userName, model.user!.name.toString());
      preferences.setString(
          ApiConstants.emailId, model.user!.emailId.toString());
      preferences.setBool("is_logged_in", true);
      return Right(model);
    } on SocketException {
      return const Left("No Internet Connection");
    } on ServerException catch (e) {
      return Left(e.message);
    } on DioException catch (e) {
      return Left(e.response?.data['error']?.toString() ??
          "Error occurred. Please try again");
    } catch (e) {
      return Left("Unexpected error: ${e.toString()}");
    }
  }
}
