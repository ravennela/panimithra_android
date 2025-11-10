import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_reviews_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/data/models/top_five_rating_model.dart';

abstract class ReviewRepository {
  Future<Either<String, SuccessModel>> addReviewRepo(
      {required String bookingId,
      required String employeeId,
      required double rating,
      required String review,
      required String serviceId});
  Future<Either<String, TopFiveRatingModel>> getTopFiveRatingsRepo(
      {required String serviceId});
  Future<Either<String, FetchReviewsModel>> fetchAllReviews({
    required String serviceId,
    required int pageNo,
  });
}
