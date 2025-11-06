import 'package:dartz/dartz.dart';
import 'package:panimithra/src/common/exception.dart';
import 'package:panimithra/src/data/datasource/remote/create_review_remote_datasource.dart';
import 'package:panimithra/src/data/models/success_model.dart';
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
    required String serviceId
  }) async {
    try {
      final response = await reviewRemoteDatasource.addReview(
        bookingId: bookingId,
        employeeId: employeeId,
        rating: rating,
        review: review,
        serviceId: serviceId
      );

      final successModel = SuccessModel.fromJson(response);
      return Right(successModel);
    } on ServerException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
