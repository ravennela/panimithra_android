
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/users_remote_datasource.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
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
}
