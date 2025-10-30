import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/data/datasource/remote/provider_registration_datasource.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/provider_registration_repository.dart';

class ProviderRegistrationImpl implements ProviderRegistrationRepository {
  ProviderRegistrationRemoteDataSourceImpl remoteDataSource;
  ProviderRegistrationImpl({required this.remoteDataSource});

  @override
  Future<Either<String, SuccessModel>> registrationCheck(
      Map<String, dynamic> data) async {
    try {
      final raw = await remoteDataSource.createProviderRegistration(data);
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
}
