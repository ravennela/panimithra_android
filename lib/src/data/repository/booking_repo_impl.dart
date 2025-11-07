import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/common/exception.dart';
import 'package:panimithra/src/data/datasource/remote/booking_remote_datasource.dart';
import 'package:panimithra/src/data/models/booking_details_model.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class BookingRepoImpl implements BookingRepository {
  final BookingRemoteDatasource remoteDatasource;
  BookingRepoImpl({required this.remoteDatasource});
  @override
  Future<Either<String, SuccessModel>> createBookingRepo(
      Map<String, dynamic> data) async {
    try {
      final response = await remoteDatasource.createBooking(data);
      final model = SuccessModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Failed to create order');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FetchBookingModel>> getBookings(int page) async {
    try {
      final raw = await remoteDatasource.getBookings(page);
      final model = FetchBookingModel.fromJson(raw);
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
  Future<Either<String, SuccessModel>> updateBookingStatusRepo({
    required String bookingId,
    required String bookingStatus,
  }) async {
    try {
      final response = await remoteDatasource.updateBookingStatus(
        bookingId: bookingId,
        bookingStatus: bookingStatus,
      );
      final result = SuccessModel.fromJson(response);
      return Right(result);
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
  Future<Either<String, BookingDetailsModel>> getBookingDetailsRepo(
      String bookingId) async {
    try {
      final response = await remoteDatasource.getBookingDetails(bookingId);
      final result = BookingDetailsModel.fromJson(response);
      return Right(result);
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
