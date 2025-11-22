import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:panimithra/src/common/exception.dart';
import 'package:panimithra/src/data/datasource/remote/review_remote_datasource.dart';
import 'package:panimithra/src/data/models/fetch_reviews_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/data/models/top_five_rating_model.dart';
import 'package:panimithra/src/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDatasource reviewRemoteDatasource;

  ReviewRepositoryImpl({required this.reviewRemoteDatasource});

  @override
  Future<Either<String, SuccessModel>> addReviewRepo({
    required String bookingId,
    required String employeeId,
    required double rating,
    required String review,
    required String serviceId,
  }) async {
    try {
      final response = await reviewRemoteDatasource.addReview(
        bookingId: bookingId,
        employeeId: employeeId,
        rating: rating,
        review: review,
        serviceId: serviceId,
      );

      final successModel = SuccessModel.fromJson(response);
      return Right(successModel);
    } // 🔹 CATCH SERVEREXCEPTION FIRST
    on ServerException catch (e) {
      return Left(e.message ?? "Server error occurred.");
    }

    // 🔹 THEN CATCH DIO EXCEPTIONS
    on DioException catch (e) {
      print("=== DIO EXCEPTION DEBUG ===");
      print("Status code: ${e.response?.statusCode}");
      print("Response data: ${e.response?.data}");
      print("Response data type: ${e.response?.data.runtimeType}");
      print("===========================");
      final backendError = e.response?.data?['error']?.toString();

      if (backendError != null && backendError.isNotEmpty) {
        return Left(backendError);
      }

      if (e.type == DioExceptionType.connectionError ||
          e.error is SocketException) {
        return const Left("No internet connection. Please try again.");
      }

      return Left(e.message ?? "Network error");
    }

    // 🔹 FALLBACK CATCH
    catch (e) {
      print("e value" + e.toString());
      return Left("Unexpected error: $e");
    }
  }

  @override
  Future<Either<String, TopFiveRatingModel>> getTopFiveRatingsRepo(
      {required String serviceId}) async {
    try {
      final response =
          await reviewRemoteDatasource.getTop5Reviews(serviceId: serviceId);
      final topFiveRatingModel = TopFiveRatingModel.fromJson(response);
      return Right(topFiveRatingModel);
    } on ServerException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FetchReviewsModel>> fetchAllReviews({
    required String serviceId,
    required int pageNo,
  }) async {
    try {
      final response = await reviewRemoteDatasource.fetchAllReviews(
        serviceId: serviceId,
        pageNo: pageNo,
      );

      final reviewsModel = FetchReviewsModel.fromJson(response);
      return Right(reviewsModel);
    } on SocketException {
      return const Left(
        "No Internet connection. Please check your network.",
      );
    } on ServerException catch (e) {
      return Left(e.message ?? "Server error occurred.");
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.message ??
          "Unexpected network error.";
      return Left("Request failed: $message");
    }

    // 🔹 Handle any other error
    catch (e) {
      return Left("Unexpected error: ${e.toString()}");
    }
  }
}
